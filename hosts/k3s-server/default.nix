{
  flake,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  defaultKubeconfig = "/etc/kubernetes/cluster-admin.kubeconfig";
  k3sFlags = [
    "--write-kubeconfig=${defaultKubeconfig}"
    "--flannel-backend=vxlan"
    "--flannel-iface=enp7s0"
    "--data-dir=/var/lib/k3s"
    "--node-taint=node-role.kubernetes.io/server=true:NoSchedule"
    "--kube-apiserver-arg enable-admission-plugins=PodNodeSelector"
    # required for anonymous access to apiserver health port
    "--kube-apiserver-arg anonymous-auth=true"
    "--datastore-endpoint=postgres:///kubernetes?host=/run/postgresql"
    "--disable=traefik"
    "--disable-cloud-controller"
  ];
  kubernetesMakeKubeconfig =
    let
      kc = "${pkgs.kubectl}/bin/kubectl";
      remarshal = "${pkgs.remarshal}/bin/remarshal";
    in
    pkgs.writeScriptBin "kubernetes-make-kubeconfig" ''
      #!${pkgs.stdenv.shell} -e
      name=''${1:-$USER}
      src_config=/etc/kubernetes/cluster-admin.kubeconfig

      ${kc} get serviceaccount $name &> /dev/null \
        || ${kc} create serviceaccount $name > /dev/null

      ${kc} get clusterrolebinding cluster-admin-$name &> /dev/null \
        || ${kc} create clusterrolebinding cluster-admin-$name \
            --clusterrole=cluster-admin --serviceaccount=default:$name \
            > /dev/null

      ${kc} get secret $name-token &> /dev/null \
        || ${kc} apply -f - <<EOF > /dev/null
      apiVersion: v1
      kind: Secret
      type: kubernetes.io/service-account-token
      metadata:
        name: $name-token
        annotations:
          kubernetes.io/service-account.name: $name
      EOF

      token=$(${kc} describe secret $name-token | grep token: | cut -c 13-)

      ${remarshal} $src_config -if yaml -of json | \
        jq --arg token "$token" \
        '.users[0].user |= (del(."client-key-data", ."client-certificate-data") | .token = $token)' \
        > /tmp/$name.kubeconfig

      KUBECONFIG=/tmp/$name.kubeconfig ${kc} config view --flatten
      rm /tmp/$name.kubeconfig
    '';
  k3s-token = config.age.secrets.k3s-token;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.k3s
    self.nixosModules.apparmor
  ];

  age.secrets.k3s-token.file = "${self}/secrets/k3s-token.age";

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    ensureDatabases = [ "kubernetes" ];
    ensureUsers = [
      {
        name = "kubernetes";
        ensureDBOwnership = true;
      }
    ];
  };

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = k3s-token.path;
    clusterInit = true;
    extraFlags = lib.concatStringsSep " " k3sFlags;
  };

  systemd.services.set-k3s-config-permissions = {
    requires = [ "k3s.service" ];
    partOf = [ "k3s.service" ];
    wantedBy = [ "k3s.service" ];
    after = [ "k3s.service" ];
    path = [ pkgs.acl ];
    script = ''
      echo "Grant abstract access to k3s config file..."
      setfacl -m g:k3s-admin:r ${defaultKubeconfig}
    '';
    serviceConfig = {
      RemainAfterExit = true;
      Type = "oneshot";
    };
  };

  environment.systemPackages = with pkgs; [
    kubectl
    stern
    config.services.k3s.package
    kubernetesMakeKubeconfig
  ];

  environment.variables.KUBECONFIG = defaultKubeconfig;
}

{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
self: super: {
    k3s = super.k3s.overrideAttrs (o: {
      tags = ["apparmor" "libsqlite3" "linux" "ctrd"];
      installPhase = ''
          # wildcard to match the arm64 build too
          install -m 0755 dist/artifacts/k3s* -D $out/bin/k3s
          wrapProgram $out/bin/k3s \
          --prefix PATH : ${self.kmod}/bin \
          --prefix PATH : ${self.socat}/bin \
          --prefix PATH : ${self.iptables}/bin \
          --prefix PATH : ${self.iproute2}/bin \
          --prefix PATH : ${self.ipset}/bin \
          --prefix PATH : ${self.bridge-utils}/bin \
          --prefix PATH : ${self.ethtool}/bin \
          --prefix PATH : ${self.util-linux}/bin \
          --prefix PATH : ${self.conntrack-tools}/bin \
          --prefix PATH : ${self.runc}/bin \
          --prefix PATH : ${self.apparmor-parser}/bin \
          --prefix PATH : "$out/bin"
          ln -s $out/bin/k3s $out/bin/kubectl
          ln -s $out/bin/k3s $out/bin/crictl
          ln -s $out/bin/k3s $out/bin/ctr
          '';
    });
  }

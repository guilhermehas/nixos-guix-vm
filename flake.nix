{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    guix.url = github:ethancedwards8/nixos-guix;
  };

  outputs = { self, nixpkgs, guix }:
  let system = "x86_64-linux";
      overlays = [ guix.overlay ];
      pkgs = import nixpkgs { inherit system overlays; };
   in rec {
    nixosConfigurations.computer = let
      inherit (nixpkgs) lib;
      modules = [
        guix.nixosModules.guix
        "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
        ./configuration.nix
      ];
    in lib.nixosSystem { inherit pkgs system modules; };
    defaultPackage.${system} = packages.${system}.vm;
    packages."${system}" = rec {
      vmWithoutSSH = nixosConfigurations.computer.config.system.build.vm;
      mkVmImg = pkgs.writeScript "mkVmImg" ''
        FILE="nixos.qcow2"
        if [ -f "$FILE"  ]; then
          echo "$FILE already exists."
        else
          ${pkgs.qemu}/bin/qemu-img create nixos.qcow2 20G
        fi
      '';
      vm = pkgs.symlinkJoin {
        name = "hello";
        paths = [ vmWithoutSSH ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/run-nixos-vm \
            --set QEMU_NET_OPTS hostfwd=tcp::2222-:22
        '';
      };
    };
  };
}

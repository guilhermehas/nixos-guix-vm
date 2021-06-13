{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    guix.url = github:ethancedwards8/nixos-guix;
  };

  outputs = { self, nixpkgs, guix }:
  let system = "x86_64-linux"; in rec
  {
    nixosConfigurations.computer = let
      overlays = [ guix.overlay ];
      pkgs = import nixpkgs { inherit system overlays; };
      inherit (nixpkgs) lib;
      modules = [
        guix.nixosModules.guix
        "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
        ./configuration.nix
      ];
    in lib.nixosSystem { inherit pkgs system modules; };
    defaultPackage."${system}" = nixosConfigurations.computer.config.system.build.vm;
  };
}

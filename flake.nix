{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    guix.url = github:ethancedwards8/nixos-guix;
  };

  outputs = { self, nixpkgs, guix } @ inputs:
  {
    nixosConfigurations.computer = let
      system = "x86_64-linux";
      overlays = [ guix.overlay ];
      pkgs = import nixpkgs { inherit system overlays; };
      inherit (nixpkgs) lib;
      # Things in this set are passed to modules and accessible
      # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
      specialArgs = {
        inherit nixpkgs;
      };
      modules = [
        guix.nixosModules.guix
        "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
        ./configuration.nix
      ];
    in lib.nixosSystem { inherit pkgs system modules; };
  };
}

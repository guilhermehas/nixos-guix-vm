# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "vim";
  virtualisation.memorySize = "20000";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
  ];

  # List services that you want to enable:
  services.guix.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedTCPPorts = [ 22 80 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the KDE Desktop Environment.
    # displayManager.lightdm.enable = true;
    displayManager.startx.enable = true;
    displayManager.autoLogin = {
      enable = true;
      user = "test";
    };

    displayManager.defaultSession = "startx";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.test = {
    isNormalUser = true;
    extraGroups = [ "wheel" "guixbuild" ]; # Enable ‘sudo’ for the user.
    initialPassword = "test";
  };
  users.users.root = {
    extraGroups = [ "guixbuild" ];
    initialPassword = "test";
  };
  users.groups.guixbuild.members = [ "root" "test" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}


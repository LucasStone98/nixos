{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
    ];

  # This assumes alot... will need to change later
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };  

  networking.hostName = "nixos-basic"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Change to your TZ
  time.timeZone = "Africa/Johannesburg";
  
  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    extraGroups = [ "wheel" "networkmanager" ]; 
    packages = with pkgs; [
      neovim
    ];
  };
  
  #environment.systemPackages = with pkgs; [
  #  
  #];
  
  system.stateVersion = "23.11"; # Did you read the comment?
  
}


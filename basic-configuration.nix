{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      /nix/hardware-configuration.nix
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
  
  environment.systemPackages = with pkgs; [
    tmux
    vim
    wget
    curl
    git
    gnumake
    unzip
  ];
  
  services.openssh.enable = true;
  
  system.stateVersion = "23.11"; # Did you read the comment?
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}


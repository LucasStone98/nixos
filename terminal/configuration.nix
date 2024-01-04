{ config, lib, pkgs, ... }:

# All of these configs assumes alot .. will need to fix this tomorrow?

let
  wallpaper_script = builtins.readFile ./scripts/wallpaper.sh;
in
{
  imports =
    [ 
      ../hardware-configuration.nix
      ./openbox.nix
    ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };  

  networking.hostName = "nixos-terminal"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Africa/Johannesburg";
  
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=0" ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    extraGroups = [ "wheel" "networkmanager" ]; 
    packages = with pkgs; [
      tree
      (writeShellScriptBin "setwall" wallpaper_script)
    ];
  };
  
  environment.systemPackages = with pkgs; [
    jq
    tmux
    neovim
    cargo
    wget
    curl
    git
    gnumake
    unzip
    feh
  ];
  
  services.openssh.enable = true;

  services.spice-vdagentd.enable = true;
  services.spice-autorandr.enable = true;
  
  system.stateVersion = "23.11"; # Did you read the comment?
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}


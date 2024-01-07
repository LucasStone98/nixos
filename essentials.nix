{ config, pkgs, lib, ... }: 

{

  services.openssh.enable = lib.mkDefault true;

  nix.settings.experimental-features = lib.mkDefault [
    "nix-command"
    "flakes"
  ];

  enviroment.systemPackages = with pkgs; [
    tmux
    vim
    wget
    curl
    git
    gnumake
    unzip
    duf
  ];

}

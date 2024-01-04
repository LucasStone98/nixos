{ pkgs, app, user, ... }:

let 
        autostart_script = ''
#!${pkgs.bash}/bin/bash

while true
do
        xterm
done
        '';

        inherit (pkgs) writeScript;
in
{
        services.xserver = {
                enable = true;
                displayManager.lightdm.enable = true;
                windowManager.openbox.enable = true;
        };

        services.xrdp = {
                enable = true;
                openFirewall = true;
        };

        nixpkgs.overlays = with pkgs; [
                (_self: super: {
                        openbox = super.openbox.overrideAttrs (_oldAttrs: rec {
                                postFixup = ''
                                        ln -sf /etc/openbox/autostart $out/etc/xdg/openbox/autostart
                                '';
                        });
                })
        ];

        environment.etc."openbox/autostart".source = writeScript "autostart" autostart_script;
}


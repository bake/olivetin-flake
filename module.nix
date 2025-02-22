{ config, pkgs, lib, ... }:

let
  cfg = config.services.olivetin;
  pkg = pkgs.callPackage ./pkg.nix { };
  webui = pkgs.callPackage ./webui.nix { };
  configDir = settings: pkgs.writeTextFile {
    name = "olivetin-config";
    destination = "/config.yaml";
    text = lib.generators.toYAML { } ({ WebUIDir = webui; } // settings);
  };
in
{
  options.services.olivetin = {
    enable = lib.mkEnableOption "Enable OliveTin";
    extraPackages = lib.mkOption {
      default = [ pkgs.bash ];
      description = ''
        Additional packages to add to the OliveTin {env}`PATH`.
      '';
      type = lib.types.listOf lib.types.package;
    };
    settings = lib.mkOption {
      default = { };
      description = ''
        Settings for OliveTin. See <https://docs.olivetin.app/config.html> for
        more information.
      '';
      example = {
        actions = [
          { title = "Hello world!"; shell = "echo 'Hello World!'"; }
        ];
      };
      type = lib.types.submodule {
        freeformType = (pkgs.formats.yaml { }).type;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.olivetin = {
      description = "OliveTin";
      wantedBy = [ "multi-user.target" ];
      path = cfg.extraPackages;
      serviceConfig = {
        ExecStart = "${pkg}/bin/OliveTin -configdir ${configDir cfg.settings}";
        Restart = "on-failure";
        Type = "exec";
      };
    };
  };
}

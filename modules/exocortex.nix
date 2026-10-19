{ config, pkgs, lib, ... }:

let
  cfg = config.services.exocortex;
  exocortexPkg = pkgs.callPackage /home/clemente/Scripts/AGENT-FLOW/default.nix {};
in
{
  options.services.exocortex = {
    enable = lib.mkEnableOption "Declarative AI Exocortex workflow system for NixOS";

    package = lib.mkOption {
      type = lib.types.package;
      default = exocortexPkg;
      description = "The exocortex-cli package derivation.";
    };

    vaultDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/vault";
      description = "Path to Obsidian / Markdown knowledge vault.";
    };

    llmCmd = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      description = "LLM execution adapter command override.";
    };
  };

  config = lib.mkIf cfg.enable {
    # 1. Package Installation
    home.packages = [
      cfg.package
      pkgs.ripgrep
      pkgs.fd
      pkgs.jq
      pkgs.xclip
      pkgs.libnotify
      pkgs.poppler-utils
    ];

    home.sessionVariables = {
      EXOCORTEX_VAULT_DIR = cfg.vaultDir;
      EXOCORTEX_LLM_CMD = cfg.llmCmd;
    };

    # 2. Systemd User Service & Timer
    systemd.user.services.exocortex-audit = {
      Unit = {
        Description = "Exocortex Epistemic Graph and Prompt Telemetry Auditor";
        After = [ "default.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${cfg.package}/bin/exo-audit";
        Environment = [
          "EXOCORTEX_VAULT_DIR=${cfg.vaultDir}"
          "PATH=${lib.makeBinPath [ pkgs.git pkgs.ripgrep pkgs.coreutils pkgs.neovim ]}"
        ];
      };
    };

    systemd.user.timers.exocortex-audit = {
      Unit = {
        Description = "Bi-weekly trigger for Exocortex audit (Sundays at 20:00)";
      };
      Timer = {
        # Fires on the 1st and 3rd Sunday of each month at 20:00
        OnCalendar = "Sun *-*-1..7,15..21 20:00:00";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}

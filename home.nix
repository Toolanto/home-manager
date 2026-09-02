{ config, pkgs, ... }:
let
  user = import ./user.nix;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  #home.username = "antonio";
  #home.homeDirectory = "/home/antonio";
  home.username = user.name;
  home.homeDirectory = user.homeDir;
  programs.direnv.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Alacritty needs nixGL to find the system's OpenGL/Mesa drivers on
    # non-NixOS distros (Ubuntu). This wraps it so nixGLIntel is used
    # automatically, and launches straight into Zellij.
    # Requires: nix profile install github:nix-community/nixGL#nixGLIntel
    (pkgs.writeShellScriptBin "alacritty-gl" ''
      exec nixGLIntel alacritty -e zellij "$@"
    '')
  ];


  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "vim";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  # Optional: Git configuration for GitHub
  programs.git = {
    enable = true;
    userName = "toolanto";
    userEmail = "toolanto@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.ssh = {
    enable = true;
    # SSH keys for Git hosting services
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_rsa";
        identitiesOnly = true;
      };
    };
  };

  programs.alacritty = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
  };

  # GNOME custom keybinding: Ctrl+Alt+T opens Alacritty (via nixGL wrapper),
  # launching straight into Zellij.
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
      # Disable Ubuntu's built-in Ctrl+Alt+T -> gnome-terminal binding
      terminal = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Alacritty";
      command = "${config.home.homeDirectory}/.nix-profile/bin/alacritty-gl";
      binding = "<Control><Alt>t";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/antonio/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    TERMINAL = "alacritty-gl";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
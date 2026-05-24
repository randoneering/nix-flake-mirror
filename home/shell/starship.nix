{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    starship = {
      enable = true;
      package = pkgs.unstable.starship;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {
        add_newline = true;
        command_timeout = 1000;

        # Catppuccin Mocha color palette format
        format = lib.concatStrings [
          "  "
          "$username"
          "$directory"
          "$git_branch"
          "$git_status"
          "$rust"
          "$python"
          "$docker_context"
          "$time"
          "\n"
          "$character"
        ];
        username = {
          show_always = true;
          style_user = "bold fg:#f9e2af";
          style_root = "bold fg:#f38ba8";
          format = "[$user ]($style)";
          disabled = false;
        };
        directory = {
          style = "bold fg:#89b4fa";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
          };
        };
        git_branch = {
          symbol = "";
          style = "bold fg:#cba6f7";
          format = "[ $symbol $branch ]($style)";
        };
        git_status = {
          style = "bold fg:#a6e3a1";
          format = "[$all_status$ahead_behind ]($style)";
          ahead = "⇡\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          behind = "⇣\${count}";
          conflicted = "=";
          untracked = "?";
          stashed = "$";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✘";
        };
        python = {
          symbol = "";
          style = "bold fg:#f9e2af";
          format = "[ $symbol ($version) ]($style)";
        };
        rust = {
          symbol = "";
          style = "bold fg:#fab387";
          format = "[ $symbol ($version) ]($style)";
        };
        docker_context = {
          symbol = "";
          style = "bold fg:#74c7ec";
          format = "[ $symbol $context ]($style)";
        };
        time = {
          disabled = false;
          time_format = "%T";
          style = "bold fg:#cdd6f4";
          format = "[  $time ]($style)";
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[](bold fg:#a6e3a1)";
          error_symbol = "[󰈸](bold fg:#f38ba8)";
        };
        nix_shell = {
          format = "[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)";
          impure_msg = "[⌽](bold dimmed red)";
          pure_msg = "[⌾](bold dimmed green)";
          style = "#74c7ec";
          symbol = "";
          unknown_msg = "[◌](bold dimmed yellow)";
        };
        aws = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#f9e2af";
          symbol = " ";
        };
        gcloud = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#89b4fa";
          symbol = "☁️ ";
        };
        azure = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#89b4fa";
          symbol = "󰠅 ";
        };
        terraform = {
          style = "bold #cba6f7";
          format = "[$symbol]($style)";
          symbol = "⬢";
        };
      };
    };
  };
}

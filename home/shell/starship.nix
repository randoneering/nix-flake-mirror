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

        # Tokyonight Night color palette
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
          style_user = "bold fg:#e0af68";
          style_root = "bold fg:#f7768e";
          format = "[$user ]($style)";
          disabled = false;
        };
        directory = {
          style = "bold fg:#7aa2f7";
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
          style = "bold fg:#bb9af7";
          format = "[ $symbol $branch ]($style)";
        };
        git_status = {
          style = "bold fg:#9ece6a";
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
          style = "bold fg:#e0af68";
          format = "[ $symbol ($version) ]($style)";
        };
        rust = {
          symbol = "";
          style = "bold fg:#ff9e64";
          format = "[ $symbol ($version) ]($style)";
        };
        docker_context = {
          symbol = "";
          style = "bold fg:#7dcfff";
          format = "[ $symbol $context ]($style)";
        };
        time = {
          disabled = false;
          time_format = "%T";
          style = "bold fg:#a9b1d6";
          format = "[  $time ]($style)";
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[](bold fg:#9ece6a)";
          error_symbol = "[󰈸](bold fg:#f7768e)";
        };
        nix_shell = {
          format = "[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)";
          impure_msg = "[⌽](bold dimmed red)";
          pure_msg = "[⌾](bold dimmed green)";
          style = "#7dcfff";
          symbol = "";
          unknown_msg = "[◌](bold dimmed yellow)";
        };
        aws = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#e0af68";
          symbol = " ";
        };
        gcloud = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#7aa2f7";
          symbol = "☁️ ";
        };
        azure = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#7aa2f7";
          symbol = "󰠅 ";
        };
        terraform = {
          style = "bold #bb9af7";
          format = "[$symbol]($style)";
          symbol = "⬢";
        };
      };
    };
  };
}

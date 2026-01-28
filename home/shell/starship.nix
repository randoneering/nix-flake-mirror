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

        # Popping and Locking color palette format
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
          style_user = "bold fg:#fabd2f";
          style_root = "bold fg:#f42c3e";
          format = "[$user ]($style)";
          disabled = false;
        };
        directory = {
          style = "bold fg:#458588";
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
          style = "bold fg:#b16286";
          format = "[ $symbol $branch ]($style)";
        };
        git_status = {
          style = "bold fg:#689d6a";
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
          style = "bold fg:#fabd2f";
          format = "[ $symbol ($version) ]($style)";
        };
        rust = {
          symbol = "";
          style = "bold fg:#f42c3e";
          format = "[ $symbol ($version) ]($style)";
        };
        docker_context = {
          symbol = "";
          style = "bold fg:#99c6ca";
          format = "[ $symbol $context ]($style)";
        };
        time = {
          disabled = false;
          time_format = "%T";
          style = "bold fg:#ebdbb2";
          format = "[  $time ]($style)";
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[](bold fg:#b8bb26)";
          error_symbol = "[󰈸](bold fg:#f42c3e)";
        };
        nix_shell = {
          format = "[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)";
          impure_msg = "[⌽](bold dimmed red)";
          pure_msg = "[⌾](bold dimmed green)";
          style = "#99c6ca";
          symbol = "";
          unknown_msg = "[◌](bold dimmed yellow)";
        };
        aws = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#fabd2f";
          symbol = " ";
        };
        gcloud = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#458588";
          symbol = "☁️ ";
        };
        azure = {
          format = " [$symbol $profile $region]($style)";
          style = "bold fg:#458588";
          symbol = "󰠅 ";
        };
        terraform = {
          style = "bold #fabd2f";
          format = "[$symbol]($style)";
          symbol = "⬢";
        };
      };
    };
  };
}

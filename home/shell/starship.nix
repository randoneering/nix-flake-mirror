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
          "[](fg:#1d2021)"
          "  "
          "$username"
          "[](bg:#3c3836 fg:#1d2021)"
          "$directory"
          "[](fg:#3c3836 bg:#504945)"
          "$git_branch"
          "$git_status"
          "[](fg:#504945 bg:#665c54)"
          "$golang"
          "$rust"
          "$python"
          "[](fg:#665c54 bg:#7c6f64)"
          "$docker_context"
          "[](fg:#7c6f64 bg:#928374)"
          "$time"
          "[ ](fg:#928374)"
          "\n"
          "$character"
        ];
        username = {
          show_always = true;
          style_user = "bold bg:#1d2021 fg:#fabd2f";
          style_root = "bold bg:#1d2021 fg:#f42c3e";
          format = "[$user ]($style)";
          disabled = false;
        };
        directory = {
          style = "bold bg:#3c3836 fg:#7ec16e";
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
          style = "bold bg:#504945 fg:#b8bb26";
          format = "[ $symbol $branch ]($style)";
        };
        git_status = {
          style = "bold bg:#504945 fg:#fabd2f";
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
          style = "bold bg:#665c54 fg:#fabd2f";
          format = "[ $symbol ($version) ]($style)";
        };
        rust = {
          symbol = "";
          style = "bold bg:#665c54 fg:#f42c3e";
          format = "[ $symbol ($version) ]($style)";
        };
        docker_context = {
          symbol = "";
          style = "bold bg:#7c6f64 fg:#99c6ca";
          format = "[ $symbol $context ]($style)";
        };
        time = {
          disabled = false;
          time_format = "%T";
          style = "bold bg:#928374 fg:#ebdbb2";
          format = "[  $time ]($style)";
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[](bold fg:#458588)";
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
          style = "bold #99c6ca";
          symbol = " ";
        };
        gcp = {
          format = " [$symbol $profile $region]($style)";
          style = "bold #99c6ca";
          symbol = "☁️ ";
        };
        azure = {
          format = " [$symbol $profile $region]($style)";
          style = "bold #99c6ca";
          symbol = "󰠅 ";
        };
        terraform = {
          style = "bold #7ec16e";
          format = "[$symbol]($style)";
          symbol = "⬢";
        };
      };
    };
  };
}

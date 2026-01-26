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
          "$directory"
          "[](bg:#3c3836 fg:#1d2021)"
          "$git_branch"
          "$git_status"
          "[](fg:#3c3836 bg:#504945)"
          "$golang"
          "$rust"
          "$python"
          "[](fg:#504945 bg:#665c54)"
          "$azure"
          "$gcp"
          "$aws"
          "[ ](fg:#665c54 bg:#7c6f64)"
          "\n"
          "$character"
        ];

        os = {
          disabled = true;
          style = "bg:#1d2021 fg:#ebdbb2";
          symbols = {
            Ubuntu = "󰕈";
            Macos = "󰀵";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };
        };
        directory = {
          style = "bold fg:#458588";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        git_branch = {
          symbol = "";
          style = "fg:#b8bb26";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bold fg:#d3869b";
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
          style = "fg:#fabd2f";
          format = "[ $symbol ($version) ]($style)";
        };
        rust = {
          symbol = "";
          style = "fg:#f42c3e";
          format = "[ $symbol ($version) ]($style)";
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[󰆼](bold #fabd2f)";
          error_symbol = "[󱘺](bold fg:#f42c3e)";
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
          format = "[$symbol  $region]($style)";
          style = "#fabd2f";
          symbol = "";
        };
        gcp = {
          format = "[$symbol  $region]($style)";
          style = "#fabd2f";
          symbol = "☁️";
        };
        azure = {
          format = "[$symbol  $region]($style)";
          style = "#fabd2f";
          symbol = "󰠅";
        };
        terraform = {
          style = "#7ec16e";
          format = " [$symbol]($style)";
          symbol = "⬢";
        };
      };
    };
  };
}

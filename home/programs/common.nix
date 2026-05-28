{pkgs, ...}: let
  floxMcpWrapper = pkgs.writeShellScriptBin "flox-mcp" ''
    unset PYTHONPATH PYTHONHOME PYTHONNOUSERSITE VIRTUAL_ENV
    exec flox activate -r flox/flox-mcp-server -- flox-mcp "$@"
  '';
  orchestramcp = pkgs.callPackage ../../pkgs/orchestra-mcp {};
in {
  home.packages = with pkgs; [
    # archives
    zip
    gtk4
    gtk3
    sassc
    meson
    libglibutil
    dig
    # utils
    btop
    dpkg
    ripgrep
    nfs-utils
    git
    wget
    awscli2
    google-cloud-sdk
    gh
    popsicle
    dconf
    freshfetch
    gimp3
    nmap
    azure-cli
    # python
    ruff
    uv

    # nix dev
    niv
    nixpkgs-review

    # IDE/Database Manager
    mongosh
    postgresql
    mysql80
    pgformatter

    # IaC
    opentofu

    # Configuration Management
    ansible

    # Steam?
    glibc

    # Security
    proton-pass
    proton-authenticator
    protonvpn-gui
    protonmail-desktop
    floxMcpWrapper
    orchestramcp
  ];

  # Proton's Electron launchers do not consistently advertise a desktop class
  # GNOME can match back to the installed desktop file, so the dock falls back
  # to the generic Electron gears icon.
  xdg.desktopEntries = {
    "proton-mail" = {
      name = "Proton Mail";
      comment = "Proton official desktop application for Proton Mail and Proton Calendar";
      genericName = "Proton Mail";
      exec = "proton-mail %U";
      icon = "proton-mail";
      type = "Application";
      startupNotify = true;
      categories = ["Network" "Email"];
      mimeType = ["x-scheme-handler/mailto"];
      settings = {
        StartupWMClass = "proton-mail";
        X-GNOME-WMClass = "proton-mail";
      };
    };

    "proton-pass" = {
      name = "Proton Pass";
      comment = "Proton Pass desktop application";
      genericName = "Password Manager";
      exec = "proton-pass %U";
      icon = "proton-pass";
      type = "Application";
      startupNotify = true;
      categories = ["Utility"];
      settings = {
        StartupWMClass = "proton-pass";
        X-GNOME-WMClass = "proton-pass";
      };
    };

    "Proton Authenticator" = {
      name = "Proton Authenticator";
      comment = "Proton Authenticator";
      exec = "proton-authenticator";
      icon = "proton-authenticator";
      type = "Application";
      terminal = false;
      categories = ["Utility"];
      settings = {
        StartupWMClass = "proton-authenticator";
        X-GNOME-WMClass = "proton-authenticator";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  unstable,
  inputs,
  hostname,
  user,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.stylix.nixosModules.stylix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
  };
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-darkgruvbox-dark.yaml";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.bluetooth.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Europe/Moscow";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services = {
    logind = {
      lidSwitch = "lock";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=lock
      '';
    };
    libinput.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    displayManager.ly.enable = true;
    xserver.enable = true;
  };

  users.users = lib.mkMerge [
    {
      "${user}" = {
        isNormalUser = true;
        extraGroups = ["wheel" "input"];
        packages = with pkgs; [];
        shell = pkgs.zsh;
      };
    }
  ];

  programs = {
    zsh.enable = true;
    mtr.enable = true;
    firefox.enable = true;
    npm.enable = true;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [stylua glibc libgcc zlib];
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "CascadiaCode" "CascadiaMono"];})
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  environment.systemPackages = with pkgs; [
    trash-cli
    rustup
    gcc
    unstable.neovim
    unstable.yazi
    unstable.hyprswitch
    appimage-run
    postgresql
    postgresql.lib
    pgadmin4
    ripgrep
    git
    gitAndTools.git-extras
    tig
    lazygit
    gh
    diff-so-fancy
    figlet
    lutris
    ntfs3g
    kitty
    pavucontrol
    pulseaudioFull
    microfetch
    nerdfetch
    cliphist
    wl-clip-persist
    wl-clipboard
    waybar
    bottles
    gource

    nodejs
    nodePackages.live-server
    libclang
    clang-tools
    lua5_1
    go
    ascii-image-converter
    cargo
    fzf
    zoxide
    rofi-wayland
    calc
    discord
    qbittorrent
    libnotify
    dunst
    eza
    luarocks-nix
    bluetui

    wget

    unzip
    zip
    wineWowPackages.waylandFull
    brightnessctl
    jetbrains.idea-community-bin

    (unstable.python3.withPackages (ps:
      with ps; [
        textual
        uv
        colorama
        psutil
        pillow
        screeninfo
      ]))

    telegram-desktop
    swww
    hyprlock
    hyprpicker
    hypridle
    bluetui
    nwg-look
  ];

  system.stateVersion = "24.11";
}

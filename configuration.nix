{ config, lib, pkgs, unstable, ... }: 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # nixpkgs.config = {
  #   packageOverrides = pkgs: with pkgs; {
  #     unstable = import unstableTarball {
  #       config = config.nixpgs.config;
  #     };
  #   };
  # };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;


  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    bluetooth.enable = true;

  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  time.timeZone = "Europe/Moscow";


  nix.settings.experimental-features = [ "nix-command" "flakes"];
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true;   
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # home-manager = {
  #   useUserPackages = true;
  #   useGlobalPkgs = true;
  #   users.beholder = ./home.nix;
  # };

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

    displayManager.sddm = {
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
    };
    #
    xserver = {
      enable = true;
    };
    #
  };


  users.users.beholder = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };


  programs = {
    zsh.enable = true;
    mtr.enable = true;
    firefox.enable = true;
    npm.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stylua
        gcc
      ];
    };
 

    hyprland = {
      enable = true;
      xwayland.enable = true;
      # portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ 
      "FiraCode"
      "JetBrainsMono"
      "CascadiaCode"
      "CascadiaMono"
    ]; })
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
    unstable.neovim
    unstable.yazi
    unstable.hyprswitch
    appimage-run
    postgresql  # основной PostgreSQL
    postgresql.lib  # содержит pg_config
    pgadmin4
    git                  # основной Git
    gitAndTools.git-extras # дополнительные команды Git
    tig                  # TUI для просмотра истории
    lazygit              # альтернативный TUI
    gh                   # GitHub CLI
    diff-so-fancy        # улучшенный git diff 
    figlet
    lutris
    ntfs3g
    kitty
    pavucontrol
    pulseaudioFull
    neofetch
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

    (unstable.python3.withPackages (ps: with ps; [
      textual
      uv
      colorama
      psutil
      pillow
      screeninfo
    ]))

    home-manager
    telegram-desktop
    swww    
    hyprlock
    hyprpicker
    hypridle
    bluetui
    nwg-look
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "24.11"; # Did you read the comment?

}


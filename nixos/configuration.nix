{ pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # ./hardware-configuration.nix
      inputs.mangowm.nixosModules.mango
    ];

	# to search, run: $ nix search wget
	environment.systemPackages = with pkgs; [
		# Theming
		banana-cursor # https://github.com/ful1e5/banana-cursors
		bibata-cursors
		lyra-cursors

		# gaming
		osu-lazer

		# Efficiency
		wl-kbptr # keyboard workflow (generic mouse replacer)

		# Hardware
		coolercontrol.coolercontrold # daemon
		coolercontrol.coolercontrol-gui
		coolercontrol.coolercontrol-ui-data
		openrgb-with-all-plugins
		playerctl
		#pavucontrol # for mic control # dont think i need this with noctalia shell


		# Security
		gnome-keyring # for wifi password and browserl ogins
		bitwarden-desktop
		kdePackages.polkit-kde-agent-1

		# Dependencies
		jq # for mango
		swaybg # for mango (???)
		# wmenu # i dont think wmenu is real
		kdePackages.kio # needed since 25.11 (DOLPHIN)
		kdePackages.kio-fuse #to mount remote filesystems via FUSE (DOLPHIN)
		kdePackages.kio-extras #extra protocols support (sftp, fish and more) (DOLPHIN)
		kdePackages.kio-admin

		# Screenshot
		grim		#Capture the screen or a region to a file
		slurp		#Interactively select a region for grim
		satty		#Annotate screenshots before saving
		wayfreeze	#Freeze the screen before capture
		wl-clipboard#ss


		# File managers
		# FOR DOLPHIN TO WORK:
		kdePackages.dolphin # This is the actual dolphin package
		yazi
		# YAZI DEPENDENCIES # didnt work idk
		#ueberzugpp          # Overlay image rendering engine for Alacritty
		#ffmpegthumbnailer   # Video thumbnails
		#imagemagick         # Image processing / SVG support
		#poppler-utils       # PDF previews (provides pdftoppm)
		#chafa               # Optional: block-art fallback


		# Text editors
		neovim
		micro
		zed-editor
		vscode
		obsidian


		# Utility
		fw-ectool # frmwk laptop
		brightnessctl
		popsicle # flashing usb
		libnotify
		p7zip # 7zip
		unrar #rar files
		solaar # for mouse
		xwayland-satellite # for steam to work
		devenv # For cachix?
		kdePackages.kcolorchooser # color picker


		# Development
		android-studio
		flutter
	  	jdk17 # appernatly version 17 is goated idk? Java.
		gh
		nodejs # obviously need this
		git
		github-desktop
		alacritty
		cool-retro-term
		docker # docker? hardly ever knew her
		cabal-install # Haskell package manager
		ghcid # Haskell compiler for fast reloading
		haskell-language-server # LSP
		ghc # Haskell compiler
		nixd # nix LSP
		python3
		cool-retro-term
		# starship # shell prompt
		#quickshell
		#qt6.qtdeclarative # LSP doesn't work with zed for some reason
		#kdePackages.qtdeclarative


		# System info
		bottom # live performance
		fastfetch # system info
		qdirstat # storage info


		# Browsers
		firefox
		vivaldi
		google-chrome
		ladybird


		# Players (music/video)
		spotatui
		mpv


		# Social media (discord)
		#discordo
		#abaddon
		dissent
		discord-ptb # proprietary garbage
		#webcord
		#legcord
		#betterdiscordctl
	];

	# programs.starship.enable = true;


    environment.shellAliases = {
        nixos-flakeswitch = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos#nixos --impure"; ## impure so i can access hardware config outside of the git repo
    };




	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ]; # experimental flakes



	hardware.graphics = {
	  enable = true;
	  enable32Bit = true;
	};

	# ssh / scp
	services.openssh.enable = true;

	# Noctalia shell dependencies
	# https://docs.noctalia.dev/noctalia/getting-started/nixos/?section=tab-panel-17#tab-panel-17
	hardware.bluetooth.enable = true;
	services.power-profiles-daemon.enable = true; # FOR POWER PROFILES
	services.upower.enable = true;
	programs.noctalia.systemd.enable = true;
	programs.noctalia.enable = true;


	# ????
	services.xserver.videoDrivers = ["amdgpu"];
	services.resolved.enable = true;


	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	# boot.initrd.luks.devices."luks-894c85be-dd74-4e85-9c39-67e8ca7ef576".device = "/dev/disk/by-uuid/894c85be-dd74-4e85-9c39-67e8ca7ef576";


 	# Networking
	networking = {
		hostName = "nixos";
		networkmanager.enable = true;
		# wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	};

	# Set your time zone.
	time.timeZone = "Europe/Copenhagen";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_DK.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "da_DK.UTF-8";
		LC_IDENTIFICATION = "da_DK.UTF-8";
		LC_MEASUREMENT = "da_DK.UTF-8";
		LC_MONETARY = "da_DK.UTF-8";
		LC_NAME = "da_DK.UTF-8";
		LC_NUMERIC = "da_DK.UTF-8";
		LC_PAPER = "da_DK.UTF-8";
		LC_TELEPHONE = "da_DK.UTF-8";
		LC_TIME = "da_DK.UTF-8";
	};



	# for systemctl hibernate to work properly.. hopefully..
	# This didn't work at all btw
  #swapDevices = [ {
  #  device = "/swap/swapfile";
  #  size = 32 * 1024;
  #} ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    config = {
	    mango = {
	    	#default = [ "wlr" "gtk" ];
	    	default = lib.mkForce [ "wlr" "gtk" ];
	    };

      #hyprland = {
        #default = [
        #  "hyprland"
       #   "kde"
      #    "gtk"
       # ];
      #};
    };
    #configPackages = with pkgs; [
	#  pkgs.xdg-desktop-portal-gtk
    #  xdg-desktop-portal-hyprland
    #  kdePackages.xdg-desktop-portal-kde
    #];
  };



	services.udisks2.enable = true; # popsicle dependency
	services.gnome.gnome-keyring.enable = true; # FOR GITHUB DEKSTOP TO AUTH
	security.pam.services.login.enableGnomeKeyring = true; # or services.sddm / services.gdm depending on your display manager

	services.displayManager = {
		defaultSession = "mango"; # derived from mango.desktop filename
		autoLogin = {
		  enable = false;
		  user = "linde";
		};

		sddm = {
			enable = true;
				wayland.enable = true;
		};
	};

	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# OpenRGB
	services.hardware.openrgb.enable = true;

	# Configure console keymap
	console.keyMap = "dk-latin1";

    programs.fish = {
        enable = false;
        interactiveShellInit = ''
            set fish_greeting # Disable greeting
        '';
    };


  # Define a user account. Don't forget to set a password with ‘passwd’.
	users.users."linde" = {
		isNormalUser = true;
		description = "the only real user";
		extraGroups = [ "networkmanager" "wheel" "docker" ];
		# packages = with pkgs; [];
		#shell = pkgs.fish;
	};

	virtualisation.vmVariant = {
		users.users.root.initialPassword = "password";
		users.users.linde.initialPassword = "password";
	};

	virtualisation.docker.enable = true;


	hardware.logitech.wireless.enable = true;

	programs.nix-ld.enable = true; # to run unpatches binaries
	programs.mango.enable = true;
	programs.mango.package = inputs.mangowm.packages.${pkgs.system}.default;

	# change bash terminal color to dark blue
	programs.bash.promptInit = ''
	  PS1='\[\033[38;2;78;115;188m\][\[\033[38;2;124;178;224m\]\u\[\033[38;2;78;115;188m\]@\[\033[38;2;124;178;224m\]\h\[\033[38;2;78;115;188m\]:\w]\$\[\033[0m\] '
	'';

	# SYSTEMD SERVICES!!!
	systemd.services.framework-led-off = {
		description = "Turn off Framework 13 power LED";
		wantedBy = [ "multi-user.target" "post-resume.target" ];
		after = [ "multi-user.target" "post-resume.target" ];
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "${pkgs.fw-ectool}/bin/ectool led power off";
		};
	};

	systemd.user.services.openrgb = {
		unitConfig = {
			Description = "Turn off RGB lighting with OpenRGB";
		};
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "${pkgs.openrgb}/bin/openrgb --brightness 0";
		};
		wantedBy = [ "default.target" ];
	};



	programs.niri = {
		enable = true;
		package = pkgs.niri;
	};

	programs.xwayland.enable = true;
	programs.gamescope.enable = true;

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

	programs.steam.package = pkgs.steam.override {
	  extraArgs = "-system-composer";
	};


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# DISABLED IN FAVOUR OF NOCTALIA LOCK # nvm
# can go here maybe https://docs.noctalia.dev/greeter/installation/?section=nixos-declarative-setup#nixos-declarative-setup
# 	programs.qylock = {
# 		enable = true;
# 		theme = "field"; # Choose any folder name from the themes/ directory in their repository
#
# 		sddm.enable = true;       # Installs the theme and activates it for SDDM (default)
# 		quickshell.enable = true; # Adds the `qylock-lock` wrapper utility to your PATH (default)
#
# 		# Optional: Per-theme overrides (replaces interactive script prompts)
# 		#themeOptions = {
# 		# terraria.backgroundMode = "time"; # time | random | static
# 		# Genshin.backgroundMode = "time";
# 		# clockwork.orbital = {
# 		#  themeMode = "dark";
# 		# enableWindup = true;
# 		#};
# 		# osu.gameMode = "menu"; # menu | game
# 		#};
# 	};


    services.displayManager.noctalia-greeter = {
        enable = true;
        settings = {
            cursor.size = 24;
            keyboard.layout = "us";
        };
        cursorTheme = {
            package = pkgs.banana-cursor;
            name = "Banana";
        };
    };

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "26.05"; # Did you read the comment?
}

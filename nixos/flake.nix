{
  description = "the best flake in the world";

	# looks like inputs are dependencies
  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    qylock.url = "github:Darkkal44/qylock";
	nixos-hardware.url = "github:NixOS/nixos-hardware/master";

	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

# outputs = { self, nixpkgs, qylock, mangowm, ... }@inputs: {
	outputs = { self, nixpkgs, qylock, mangowm, nixos-hardware, home-manager, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
	  specialArgs =  { inherit inputs; }; # NOT USED YET!

      modules = [
		# nixos can't use ~/ for home dir
        ./configuration.nix
        nixos-hardware.nixosModules.framework-13-7040-amd
        qylock.nixosModules.default

		home-manager.nixosModules.home-manager {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;

			home-manager.users.linde = { config, ... }: {
				home.username = "linde";
				home.homeDirectory = "/home/linde";
				home.stateVersion = "24.05";

				# New noctalia V5 config (i hate that it isn't in .conf)
				# THIS IS THE MOST CURSED THING I HAVE EVER CREATED IT'S TERRIBLE (im keeping it)
                home.file.".local/state/noctalia/settings.toml".source =
                    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia/state/settings.toml";

				xdg.configFile."mango".source = config.lib.file.mkOutOfStoreSymlink
					"${config.home.homeDirectory}/dotfiles/mango";

				xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink
					"${config.home.homeDirectory}/dotfiles/niri";

				xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink
					"${config.home.homeDirectory}/dotfiles/alacritty";

				xdg.configFile."zed".source = config.lib.file.mkOutOfStoreSymlink
					"${config.home.homeDirectory}/dotfiles/zed";

				xdg.configFile."mpv".source = config.lib.file.mkOutOfStoreSymlink
					"${config.home.homeDirectory}/dotfiles/mpv";

				# less friction if i ever wanna learn
				xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
					"${config.home.homeDirectory}/dotfiles/nvim";


				# commands to backup
				# cp -r ~/.config/mpv ~/dotfilesbackup/mpv
				# rm -r ~/.config/mpv
				# mv maybe will be something

				programs.home-manager.enable = true;
			};
		}
      ];
    };
  };
}




# noctalia old stuff

# ".local/share/noctalia".source =
#     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia/share";

# mystery error. keep it
# ".local/share/noctalia".source =
#     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia/share";

# ".local/state/noctalia/plugins/data".source =
#     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctaliav5/plugins/data";
# take plugins data and materialized, since sources isn't real
# ".local/state/noctalia/plugins/materialized".source =
#    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctaliav5/materialized";

# I DO NOT THINK I NEED THESE TWO (noctalia)
#    ".local/state/noctalia/community-palettes".source =
#        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctaliav5/community-palettes";
#    ".local/state/noctalia/community-templates".source =
#        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctaliav5/community-templates";

{
  description = "A simple NixOS flake";

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
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        nixos-hardware.nixosModules.framework-13-7040-amd
        qylock.nixosModules.default


		home-manager.nixosModules.home-manager {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;

			home-manager.users.linde = { config, pkgs, ... }: {
				home.username = "linde";
				home.homeDirectory = "/home/linde";
				home.stateVersion = "24.05";

				xdg.configFile."mango".source = config.lib.file.mkOutOfStoreSymlink 
					"${config.home.homeDirectory}/dotfiles/mango";

				xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink 
					"${config.home.homeDirectory}/dotfiles/noctalia";

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


				# commands
				# cp -r ~/.config/mpv ~/dotfilesbackup/mpv
				# rm -r ~/.config/mpv

				programs.home-manager.enable = true;
			};
		}
      ];
    };
  };
}

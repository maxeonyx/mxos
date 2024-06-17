{
  description = "Max's NixOS config.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    # Nixpkgs unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # VS Code server patching
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    # Nix language server
    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs"; # if nil breaks, comment this out.
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    vscode-server,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      mx-hyb-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs unstable; };
        # > Our main nixos configuration file <
        modules = [
          {
            disabledModules = [ "system/boot/plymouth.nix" ];
          }
        
          ./hyperv-guest.nix
          ./mx-hyb-nixos.nix
          ./system.nix

          home-manager.nixosModules.home-manager
          ({config, pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maxeonyx = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          })

          # VS Code server
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
          ./system/vscode.nix
          
          ./system/plymouth-patched.nix
        ];
      };
    };
  };
}

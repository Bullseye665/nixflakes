{
  description = "Person's hopeful nixflake.";
  # nix flake update /home/person/nixflakes/
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = { url = "github:hyprwm/hyprland"; };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    eriixpkgs = {
#      url = "github:erictossell/eriixpkgs";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

#    NixOS-WSL = {
#      url = "github:nix-community/NixOS-WSL";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    nix-gaming = {
#      url = "github:fufexan/nix-gaming";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

#    nurpkgs = {
#      url = github:nix-community/NUR;
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

#    disko = {
#      url = "github:nix-community/disko";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

#    nixos-anywhere = {
#      url = "github:numtide/nixos-anywhere";
#      inputs = {
#        nixpkgs.follows = "nixpkgs";
#        disko.follows = "disko";
#      };
#    };

    xlibre-overlay.url = "git+https://codeberg.org/takagemacoed/xlibre-overlay";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    };

  outputs = { self, nixpkgs, nixos-hardware, nix-flatpak, ... }@attrs:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {

      nixosConfigurations = {
        # Available by nixos-rebuild [ switch test ] --flake /home/person/nixflakes#person
        person = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = "person";
            hostName = "nixos";
            version = "25.11";
            hyprlandConfig = "desktop.nix";
            inherit system;
          } // attrs;
          modules = [
            ./.
          ];
        }; # Person

        framework = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = "framework";
            hostName = "nixos";
            version = "25.11";
            hyprlandConfig = "laptop.nix";
            inherit system;
          } // attrs;
          modules = [
            ./.
          ];
        }; # framework

        incus = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            username = "incus";
            hostName = "general";
            version = "25.11";
            inherit system;
          } // attrs;
          modules = [
            ./.
          ];
        }; # incus

        nix-master = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            username = "nix-master";
            hostName = "lesser";
            version = "25.11";
            inherit system;
          } // attrs;
          modules = [
            ./.
          ];
        }; # master

        security = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = "security";
            hostName = "lesser";
            version = "25.11";
            hyprlandConfig = "laptop.nix";
            inherit system;
          } // attrs;
          modules = [
            ./.
          ];
        }; # security

        userland = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = "userland";
            hostName = "lesser";
            version = "25.11";
            hyprlandConfig = "laptop.nix";
            inherit system;
          } // attrs;
          modules = [
            ./.
          ];
        }; # userland

        live-image = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            username = "live-image";
            hostName = "live";
            hyprlandConfig = "laptop.nix";
            version = "25.11";
            inherit system;
          } // attrs;
          modules = [ ./minimal.nix ];
        }; # Live-image

        winix = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            username = "winix";
            hostName = "lesser";
            version = "25.11";
            inherit system;
          } // attrs;
          modules = [ ./wsl.nix ];
        }; # winix-wsl

        virtualis = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            username = "virtualis";
            hostName = "eriim";
            version = "23.11";
            inherit system;
          } // attrs;
          modules = [ ./minimal.nix ];
        }; # virtualis
      }; # configurations

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default =
            pkgs.mkShell { buildInputs = with pkgs; [ nixfmt statix ]; };
        });

      templates.default = {
        path = ./.;
        description = "The default template for Person's nixflakes.";
      }; # templates

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}

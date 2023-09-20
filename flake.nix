# gonzo flake

{
  description = "flake for gonzo";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      gonzo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.viktor = { pkgs, ... }: {
              home.username = "viktor";
              home.homeDirectory = "/home/viktor";
              home.stateVersion = "23.05";

              home.packages = with pkgs; [
                discord
                file
                k9s
                slack
                spotify
                tmux
              ];

              programs.home-manager.enable = true;

              programs.direnv.enable = true;

              programs.git = {
                enable = true;
                userName = "Viktor Elofsson";
                userEmail = "viktor@viktorelofsson.se";
              };

              programs.zsh = {
                enable = true;
                oh-my-zsh = {
                  enable = true;
                  plugins = ["docker-compose" "docker"];
                  theme = "robbyrussell";
                };
              };

              services.dunst = {
                enable = true;

                settings = {
                  global = {
                    markup = "yes";
                    plain_text = "no";

                    format = ''
                      %a
                      <b>%s</b>
                      %b'';

                    origin = "top-center";
                  };
                };
              };

              xsession.windowManager.i3 = {
                enable = true;
                config = {
                  modifier = "Mod4";

                  keybindings = nixpkgs.lib.mkOptionDefault {
                    "Mod4+Return" = "exec kitty";
                    "Mod4+l" = "exec ${pkgs.xsecurelock}/bin/xsecurelock";
                  };

                  bars = [
                    {
                      position = "top";
                    }
                  ];
                };
              };
            };
          }
        ];
      };
    };
  };
}

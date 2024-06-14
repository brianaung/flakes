{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    phps.url = "github:fossar/nix-phps";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, phps, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            phpPkgs = phps.packages.${system};
            config = self.devShells.${system}.default.config;
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  languages.php.enable = true;
                  languages.php.package = phpPkgs.php83;

                  packages = [
                    pkgs.nodejs_21
                    pkgs.phpactor
                    pkgs.tailwindcss-language-server
                  ];

                  services.mysql = {
                    enable = true;
                    initialDatabases = [{ name = "demo"; }];
                    ensureUsers = [
                      {
                        name = "user";
                        password = "password";
                        ensurePermissions = { "user.*" = "ALL PRIVILEGES"; };
                      }
                    ];
                  };

                  languages.php.fpm.pools.web = {
                    settings = {
                      "clear_env" = "no";
                      "pm" = "dynamic";
                      "pm.max_children" = 10;
                      "pm.start_servers" = 2;
                      "pm.min_spare_servers" = 1;
                      "pm.max_spare_servers" = 10;
                    };
                  };

                  services.nginx = {
                    enable = true;
                    httpConfig = ''
                      server {
                          listen 8080;
                          listen [::]:8080;
                          server_name laravel.example.com;
                          root ${builtins.getEnv "PWD"}/public;

                          add_header X-Frame-Options "SAMEORIGIN";
                          add_header X-Content-Type-Options "nosniff";

                          index index.php;

                          charset utf-8;

                          location / {
                              try_files $uri $uri/ /index.php?$query_string;
                          }

                          location = /favicon.ico { access_log off; log_not_found off; }
                          location = /robots.txt  { access_log off; log_not_found off; }

                          error_page 404 /index.php;

                          location ~ \.php$ {
                              fastcgi_pass unix:${config.languages.php.fpm.pools.web.socket};
                              fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
                              include ${pkgs.nginx}/conf/fastcgi_params;
                              fastcgi_hide_header X-Powered-By;
                          }

                          location ~ /\.(?!well-known).* {
                              deny all;
                          }
                      }
                    '';
                  };
                }
              ];
            };
          });
    };
}

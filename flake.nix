{
  description = "Brian's flake templates";

  outputs =
    { nixpkgs, self, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgs;
    in
    {
      templates =
        {
          rust-basic = {
            path = ./rust-basic;
            description = "Flake for a basic rust project.";
          };
          laravel = {
            path = ./laravel;
            description = "Flake for a laravel project.";
          };
          lua-neovim = {
            path = ./lua-neovim;
            description = "Flake for a writing Neovim plugin in Lua.";
          };
          react = {
            path = ./react;
            description = "Flake for react projects.";
          };
          phoenix = {
            path = ./phoenix;
            description = "Flake for phoenix projects.";
          };
        };
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };

}

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
            description = "A simple flake for a basic rust project.";
          };
          laravel = {
            path = ./laravel;
            description = "A flake for a laravel project.";
          };
        };
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };

}

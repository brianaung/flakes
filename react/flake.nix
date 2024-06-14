{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgs;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_20
          tsserver
          tailwindcss-language-server
          prettierd
        ];
      };
    };
}

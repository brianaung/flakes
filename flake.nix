{
  description = "Brian's flake templates";

  outputs =
    { self, ... }:
    {
      templates = {
        rust-basic = {
          path = ./rust-basic;
          description = "A simple flake for a basic rust project.";
        };
        laravel = {
          path = ./laravel;
          description = "A flake for a laravel project.";
        };
      };
    };
}

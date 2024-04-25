{
  description = "Brian's flake templates";

  outputs =
    { self, ... }:
    {
      templates = {
        rust-starter = {
          path = ./rust-starter;
          description = "A simple Rust starter flake";
        };
      };
    };
}

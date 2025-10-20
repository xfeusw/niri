{
  description = "Niri setup for Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    niri,
    flake-utils,
    ...
  }: {
    # Re-export the niri homeModules
    homeModules = niri.homeModules;

    # Export your configuration as a simple homeManagerModule
    homeManagerModules.default = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [
        ./config/default.nix
      ];
    };
  };
}

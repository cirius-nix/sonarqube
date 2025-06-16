{
  description = "Sonarqube";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall = {
        root = ./.;
        meta = {
          title = "Sonarqube Service";
          name = "sonarqube-service";
        };
        namespace = "sonarqube";
      };
      channels-config = {
        allowUnfree = false;
      };
    };
}

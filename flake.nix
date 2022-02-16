{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nagynur.url = "github:nagy/nur-packages";
    nagynur.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nagynur, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in with pkgs; rec {
        defaultPackage = stdenvNoCC.mkDerivation rec {
          name = "json2dbus";
          src = self;
          buildInputs = [
            (python3.withPackages (ps:
              with ps;
              [ nagynur.legacyPackages.${system}.python3Packages.dbussy ]))
          ];
          buildPhase = ''
            patchShebangs json2dbus
          '';
          installPhase = ''
            install -Dm755 json2dbus $out/bin/json2dbus
          '';
          meta = {
            description = "A tool to translate JSON lines to DBUS messages";
            license = nixpkgs.lib.licenses.agpl3;
            platforms = nixpkgs.lib.platforms.linux;
            homepage = "https://github.com/nagy/json2dbus";
          };
        };
      });
}

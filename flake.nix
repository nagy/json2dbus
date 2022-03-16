{
  outputs = { self, nixpkgs, nur, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs {
        inherit system;
        overlays = [ nur.overlay ];
      }; {
        packages.default = stdenvNoCC.mkDerivation {
          name = "json2dbus";
          src = self;
          buildInputs = [
            (python3.withPackages
              (ps: [ pkgs.nur.repos.nagy.python3Packages.dbussy ]))
          ];
          installPhase = ''
            install -Dm755 json2dbus $out/bin/json2dbus
          '';
          meta = with lib; {
            description = "A tool to translate JSON lines to DBUS messages";
            license = licenses.agpl3;
            platforms = platforms.linux;
            homepage = "https://github.com/nagy/json2dbus";
          };
        };
      });
}

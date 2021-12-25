{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nagynur.url = "github:nagy/nur-packages";
  };
  outputs = { self, nixpkgs, nagynur }: rec {
    defaultPackage.x86_64-linux =
      nixpkgs.legacyPackages.x86_64-linux.stdenvNoCC.mkDerivation rec {
        name = "json2dbus";
        src = self;
        buildInputs = [
          (nixpkgs.legacyPackages.x86_64-linux.python3.withPackages (
            ps: with ps;[
              nagynur.packages.x86_64-linux.dbussy
            ]
          ))
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
  };
}

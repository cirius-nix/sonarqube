{
  fetchzip,
  stdenv,
  pkgs,
  lib,
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  platformSubdir =
    if system == "x86_64-linux" then
      "linux-x86-64"
    else if system == "aarch64-darwin" || system == "x86_64-darwin" then
      "macosx-universal-64"
    else
      throw "Unsupported platform: ${system}";

in
stdenv.mkDerivation rec {
  pname = "sonarqube";
  version = "25.5.0.107428";
  name = "${pname}-${version}";

  src = fetchzip {
    url = "https://binaries.sonarsource.com/Distribution/sonarqube/${name}.zip";
    hash = "sha256-IlDIl9nN9pxq/VjDCIL0JPMD8VFqb/QgTsF84RnegaE=";
  };

  buildInputs = [
    pkgs.procps # provide `ps` command.
  ];

  installPhase =
    ''
      set -eux

      mkdir $out
      cp -r . $out

      # patch sonar.sh to use procps ps from nix store
      substituteInPlace $out/bin/${platformSubdir}/sonar.sh \
        --replace "/usr/bin/ps" "${pkgs.procps}/bin/ps"

      substituteInPlace $out/bin/${platformSubdir}/sonar.sh \
        --replace "../../logs/nohup.log"  "\$NOHUPDIR/nohup.log"

      mkdir $out/extensions/downloads
    ''
    + (
      let
        orgCmd1 = ''pidtest=`$PSEXE -p $pid | grep "sonar-application-${version}.jar" | tail -1`'';
        cmd1 = ''pidtest=$(pgrep -f "sonar-application-${version}.jar")'';

        orgCmd2 = "pid=`$PSEXE -p $pid | grep $pid | grep -v grep | awk '{print $1}' | tail -1`";
        cmd2 = ''pid=$(pgrep -f "sonar-application-${version}.jar")'';
      in
      if (stdenv.isAarch64 && stdenv.isDarwin) then
        ''
          substituteInPlace $out/bin/${platformSubdir}/sonar.sh \
            --replace ${lib.escapeShellArg orgCmd1} ${lib.escapeShellArg cmd1} \
            --replace ${lib.escapeShellArg orgCmd2} ${lib.escapeShellArg cmd2}
        ''
      else
        ""
    );

}

{
  mkShell,
  namespace,
  pkgs,
}:
mkShell {
  packages = [
    pkgs.${namespace}.sonarqube
  ];
}

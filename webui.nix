{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "OliveTin";
  version = "2025.2.19";

  src = (fetchFromGitHub {
    owner = "OliveTin";
    repo = pname;
    rev = version;
    hash = "sha256-Wa8hpykJ5iwr6jnh+TxM/QJhmvf1mkt2HuehiTZZnsc=";
  }) + /webui.dev;

  npmDepsHash = "sha256-VxIPjpsbxEPP15cu5Wvz0qeDGXTMb2tojdry8YaHMVI=";

  buildPhase = ''
    npx parcel build --public-url "."
  '';

  installPhase = ''
    mkdir -p $out
    cp *.png dist/* $out
  '';
}

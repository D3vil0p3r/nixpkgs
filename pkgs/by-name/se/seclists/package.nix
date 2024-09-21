{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  archivesToExtract ? [ ],
  unzip,
}:

let
  pname = "seclists";
in
  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "2024.2";

    src = fetchFromGitHub {
      owner = "danielmiessler";
      repo = "SecLists";
      rev = "2024.2";
      hash = "sha256-qqXOLuZOj+mF7kXrdO62HZTrGsyepOSWr5v6j4WFGcc=";
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/wordlists/seclists
      for file in ${builtins.toString archivesToExtract}; do
        DIR="$(dirname $file)"
        case "$file" in
          *.tar.gz)
            tar -zxvf "$file" -C "$DIR"
            ;;
          *.zip)
            unzip "$file" -d "$DIR"
            ;;
        esac
        rm "$file"
      done

      find . -maxdepth 1 -type d -regextype posix-extended -regex '^./[A-Z].*' -exec cp -R {} $out/share/wordlists/seclists \;
      find $out/share/wordlists/seclists -name "*.md" -delete

      runHook postInstall
    '';

    meta = {
      description = "Collection of multiple types of lists used during security assessments, collected in one place";
      homepage = "https://github.com/danielmiessler/seclists";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        tochiaha
        pamplemousse
        d3vil0p3r
      ];
    };
  }

{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "shantell-sans";
  version = "1.011";

  src = fetchzip {
    url = "https://github.com/arrowtype/shantell-sans/releases/download/1.011/Shantell_Sans_${version}.zip";
    hash = "sha256-xgE4BSl2A7yeVP5hWWUViBDoU8pZ8KkJJrsSfGRIjOk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 Desktop/*.ttf -t $out/share/fonts/truetype
    install -Dm444 Desktop/Static/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    homepage = "https://shantellsans.com";
    description = "Shantell Sans, from Shantell Martin, is a marker-style font built for creative expression, typographic play, and animation.";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}

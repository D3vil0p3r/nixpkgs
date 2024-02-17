{ lib
, stdenv
, fetchurl
, fetchpatch
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pasco";
  version = "20040505_1";

  src = fetchurl {
    url = "mirror://sourceforge/project/fast/Pasco/Pasco%20v${finalAttrs.version}/pasco_${finalAttrs.version}.tar.gz";
    hash = "sha256-o7jue+lgVxQQvFZOzJMGd1WihlD7Nb+1WaSutq9vaGg=";
  };

  patches = [
    # add missing string.h include.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/pasco/-/raw/3379029e05906b521945e60cf463e35fbb2d759f/debian/patches/20_add-missing-string.h-include.patch";
      hash = "sha256-GXWF0t3h+KPmCkS5wrubfHBwPb0t5kiT4Au0gVxS3gw=";
    })
  ];

  makeFlags = [
    "-C src"
  ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace gcc cc
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/pasco $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Examine the contents of Internet Explorer's cache files for forensic purposes";
    homepage = "https://sourceforge.net/projects/fast/files/Pasco/";
    license = with licenses; [ bsd3 ];
    mainProgram = "pasco";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
})

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "restinio";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "aberaud";
    repo = "restinio";
    rev = "7743d63325ad20ac87331c110f064f5f55defb40";
    sha256 = "1l98rvakaiz82qbiazb0yl6czajmmqcpdfydazndwnjbiq30c1nl";
  };

  installPhase = ''
    mkdir -p $out/include
    cp -R $src/dev/restinio $out/include/
  '';

  meta = with stdenv.lib; {
    description = "A header-only C++14 library that gives you an embedded HTTP/Websocket server";
    homepage    = "https://github.com/Stiffstream/restinio";
    platforms   = platforms.linux; # ??? FIX
    license     = licenses.mit; # ??? FIX
  };
}

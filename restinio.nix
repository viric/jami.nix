{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "restinio";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "aberaud";
    repo = "restinio";
    rev = "a7a10e419d9089c5b8ee63f5e3098c892f22fae4";
    sha256 = "07x3lxrygaj33gamqykr1737qzr6ljav7hdx08k7ida3gd3r4ski";
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

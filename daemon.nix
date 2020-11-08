{ stdenv, fetchgit, fetchFromGitHub

# build infra
, autoreconfHook, autoconf-archive, automake
, libtool, m4, pkgconfig,file, cmake

# deps
, jsoncpp, zlib, pjsip, libyamlcpp, alsaLib, libpulseaudio
, libarchive
, openssl, ffmpeg, libudev, speex, secp256k1, opendht
, msgpack, libupnp, libnatpmp, gnutls, asio, libargon2
, readline, dbus, dbus_cplusplus, restinio, fmt, http-parser
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "ring-daemon";
  version = src.rev;
  nativeBuildInputs =
    [ autoreconfHook autoconf-archive automake libtool m4
      pkgconfig file
    ];

  enableParallelBuilding = true;

  # TODO: verify that all these deps are actually necessary
  buildInputs =
    [ jsoncpp zlib pjsip libyamlcpp alsaLib libpulseaudio
      openssl ffmpeg libudev speex secp256k1 opendht
      msgpack libupnp libnatpmp gnutls asio readline
      libargon2 dbus dbus_cplusplus buildPackages.perl
      restinio libarchive

      # those are actually dependencies of restinio, but it's
      # header-only so we "delay" by making them deps here
      fmt http-parser
    ];

  #makeFlags = [ "V=1" ];

  src = fetchgit {
    url = "https://git.jami.net/savoirfairelinux/ring-daemon.git";
    rev = "7eb1e7373d48fa4c23f142b0b70c09f437d22e36";
    sha256 = "054pg94vhcy7n5mdx6q1lwraq6rv5w7hqqvpjxnjp1z3x4462x1b";
  };


  meta = with stdenv.lib; {
    description = "Jami daemon";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

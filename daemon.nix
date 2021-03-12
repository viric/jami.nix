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
    rev = "821ec73a3d9dc617de4236e2013735cea8e95eb3";
    sha256 = "0i041yl9ab526apclp5194aifmd2qx3q7mrs9dnswz6rjsfasw4y";
  };


  meta = with stdenv.lib; {
    description = "Jami daemon";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

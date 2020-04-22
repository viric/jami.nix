{ stdenv, fetchgit

# build infra
, autoreconfHook, autoconf-archive, automake
, libtool, m4, pkgconfig,file

# deps
, jsoncpp, zlib, pjsip, libyamlcpp, alsaLib, libpulseaudio
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

  # TODO: verify that all these deps are actually necessary
  buildInputs =
    [ jsoncpp zlib pjsip libyamlcpp alsaLib libpulseaudio
      openssl ffmpeg libudev speex secp256k1 opendht
      msgpack libupnp libnatpmp gnutls asio readline
      libargon2 dbus dbus_cplusplus buildPackages.perl
      restinio

      # those are actually dependencies of restinio, but it's
      # header-only so we "delay" by making them deps here
      fmt http-parser
    ];

  makeFlags = [ "V=1" ];

  src = fetchgit {
    url = "https://git.jami.net/savoirfairelinux/ring-daemon.git";
    rev = "d89bccf009d83cab23a14f46af44a2f670717440";
    sha256 = "1rkzq924w8wayfvlh6p4c3p9fx751dbsq3gjdwvmmkf7962f3kmb";
  };


  meta = with stdenv.lib; {
    description = "Jami daemon";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

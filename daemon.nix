{ stdenv, fetchFromGitHub

# build infra
, autoreconfHook, autoconf-archive, automake
, libtool, m4, pkgconfig,file

# deps
, jsoncpp, zlib, pjsip, libyamlcpp, alsaLib, libpulseaudio
, openssl, ffmpeg, libudev, speex, secp256k1, opendht
, msgpack, libupnp, libnatpmp, gnutls, asio, libargon2
, readline
}:

let maintainers = { alp = "alp"; };
in

stdenv.mkDerivation rec {
  pname = "jami-daemon";
  version = src.rev;
  nativeBuildInputs =
    [ autoreconfHook autoconf-archive automake libtool m4
      pkgconfig file
    ];

  buildInputs =
    [ jsoncpp zlib pjsip libyamlcpp alsaLib libpulseaudio
      openssl ffmpeg libudev speex secp256k1 opendht
      msgpack libupnp libnatpmp gnutls asio readline
      libargon2
    ];

  src = import ./daemon-src.nix { inherit fetchFromGitHub; };

  meta = with stdenv.lib; {
    description = "Jami daemon";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ alp ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub
, cmake, pkg-config
, asio, nettle, gnutls, msgpack, readline, libargon2
, restinio, jsoncpp, openssl, fmt, http-parser, libtasn1
, p11-kit
}:

stdenv.mkDerivation rec {
  pname = "opendht";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "7628aab230ea78cae52a8e57a32a150a13b17275";
    sha256 = "1q1fwk8wwk9r6bp0indpr60ql668lsk16ykslacyhrh7kg97kvhr";
  };

  nativeBuildInputs =
    [ cmake
      pkg-config
    ];

  cmakeFlags = [ "-DOPENDHT_HTTP=ON" ];

  buildInputs =
    [ asio nettle gnutls msgpack readline libargon2
      restinio jsoncpp openssl         # for the http proxy
      fmt http-parser libtasn1 p11-kit # ditto
    ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with stdenv.lib; {
    description = "A C++11 Kademlia distributed hash table implementation";
    homepage    = "https://github.com/savoirfairelinux/opendht";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch thoughtpolice ];
    platforms   = platforms.linux;
  };
}

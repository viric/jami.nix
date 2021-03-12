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
    rev = "2256434ec7a81c8d98fcaab623cd3b75a413e4ce"; # 2021-03-12
    sha256 = "048jrma99snq6mjv8lfmmqkkrd7rlldbfknqci7baainy4q80j0w";
  };

  nativeBuildInputs =
    [ cmake
      pkg-config
    ];

  cmakeFlags = [ "-DOPENDHT_HTTP=ON" "-DOPENDHT_STATIC=OFF" ];

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

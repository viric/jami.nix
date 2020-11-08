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
    rev = "05b95331d8fa5159a69e6c8fd6dae8135a805bf9"; # 2020-11-4
    sha256 = "0877b6njypwcal5xz6ab2bhzdps0m5zv7qw9wj2fx4sgk1x5alnc";
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

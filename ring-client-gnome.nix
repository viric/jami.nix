{ stdenv, fetchgit
, cmake, pkgconfig, git, doxygen, graphviz
, lrc, gtk3, qtbase, pcre, libpthreadstubs, libXdmcp
, clutter, clutter-gtk, libqrencode, webkitgtk
, libnotify, libcanberra-gtk3, libappindicator-gtk3
, utillinuxMinimal, libselinux, libsepol, epoxy, at-spi2-core
, libXtst, libpsl, networkmanager
, gnome3, wrapGAppsHook, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ring-client-gnome";
  version = src.rev;
  nativeBuildInputs = [ cmake pkgconfig git doxygen graphviz  wrapQtAppsHook ];
  buildInputs =
    [ lrc gtk3 pcre libpthreadstubs libXdmcp clutter
      clutter-gtk libqrencode webkitgtk libnotify
      libcanberra-gtk3 libappindicator-gtk3
      utillinuxMinimal # for 'mount' package (lib?)
      libselinux libsepol epoxy at-spi2-core libXtst
      libpsl networkmanager
      gnome3.adwaita-icon-theme wrapGAppsHook
      qtbase
    ];

  src = fetchgit {
    url = "https://git.jami.net/savoirfairelinux/ring-client-gnome.git";
    rev = "a7b6be4507d1f3b3ffebd4e283ee56b9599897ac";
    sha256 = "0bfwk1fa1lhqzw81jmbpsrq8qaazj1gvsl92aqcnlgs7vbrdr7lx";
  };

  # for some reason, the gnome client's web/ folder contains
  # symlinks to files that live in libringclient's repo,
  # assuming we're working from the ring-project repo that
  # has everything as submodules.
  # instead I remove the symlinks and copy the relevant files
  preConfigure = ''
    rm -rf ./web/*
    cmd="cp ${lrc.src}/src/web-chatview/* ./web/"
    echo "copying: $cmd"
    $cmd
  '';

  meta = with stdenv.lib; {
    description = "Jami Gnome client";
    homepage = "https://jami.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

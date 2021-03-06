{ lib, stdenv, fetchFromGitHub, makeDesktopItem, pkgconfig, cmake
, wrapQtAppsHook, qtbase, bluez, ffmpeg_3, libao, libGLU, libGL, pcre, gettext
, libXrandr, libusb1, lzo, libpthreadstubs, libXext, libXxf86vm, libXinerama
, libSM, libXdmcp, readline, openal, udev, libevdev, portaudio, curl, alsaLib
, miniupnpc, enet, mbedtls, soundtouch, sfml
, vulkan-loader ? null, libpulseaudio ? null, libpng, hidapi,

# - Inputs used for Darwin
# , CoreBluetooth, ForceFeedback, IOKit, OpenGL, libpng, hidapi }:
}:

let
  desktopItem = makeDesktopItem {
    name = "dolphin-emu-master";
    exec = "dolphin-emu-master";
    icon = "dolphin-emu";
    comment = "A Wii/GameCube Emulator";
    desktopName = "Dolphin Emulator (master)";
    genericName = "Wii/GameCube Emulator";
    categories = "Game;Emulator;";
    startupNotify = "false";
  };
in stdenv.mkDerivation rec {
  pname = "dolphin-emu";
  version = "5.0-12247";

  src = builtins.fetchGit {
    url = https://github.com/dolphin-emu/dolphin;
    rev = "9c12a843f86d39bc64d9e9b5b670e67455487739";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ]
  ++ lib.optional stdenv.isLinux wrapQtAppsHook;

  buildInputs = [
    curl ffmpeg_3 libao libGLU libGL pcre gettext libpthreadstubs libpulseaudio
    libXrandr libXext libXxf86vm libXinerama libSM readline openal libXdmcp lzo
    portaudio libusb1 libpng hidapi miniupnpc enet mbedtls soundtouch sfml
    qtbase
  ] ++ lib.optionals stdenv.isLinux [
    bluez udev libevdev alsaLib vulkan-loader
  ];

  cmakeFlags = [
    "-DUSE_SHARED_ENET=ON"
    "-DENABLE_LTO=ON"
    "-DDOLPHIN_WC_REVISION=${src.rev}"
    "-DDOLPHIN_WC_DESCRIBE=${version}"
    "-DDOLPHIN_WC_BRANCH=master"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOSX_USE_DEFAULT_SEARCH_PATH=True"
  ];

  qtWrapperArgs = lib.optionals stdenv.isLinux [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  # - Allow Dolphin to use nix-provided libraries instead of building them
  postPatch = ''
    sed -i -e 's,DISTRIBUTOR "None",DISTRIBUTOR "NixOS",g' CMakeLists.txt
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i -e 's,if(NOT APPLE),if(true),g' CMakeLists.txt
    sed -i -e 's,if(LIBUSB_FOUND AND NOT APPLE),if(LIBUSB_FOUND),g' \
      CMakeLists.txt
  '';

  postInstall = ''
    cp -r ${desktopItem}/share/applications $out/share
    ln -sf $out/bin/dolphin-emu $out/bin/dolphin-emu-master
  '';

  meta = with lib; {
    homepage = "https://dolphin-emu.org";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MP2E ashkitten ];
    branch = "master";
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    broken = stdenv.isDarwin;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

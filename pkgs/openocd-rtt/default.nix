{ stdenv, lib, fetchgit, fetchpatch, libftdi1, libusb1, pkgconfig, hidapi,
  which, libtool, automake, autoconf, git }:

stdenv.mkDerivation rec {
  pname = "openocd-rtt";
  version = "0.10.0-rtt";

  src = fetchgit {
    leaveDotGit = true;
    url = "https://git.code.sf.net/p/openocd/code";
    rev = "07df04b3b1eca3b920a9b4b411883d9d44fd06e5";
    sha256 = "11pcjlz2rrbgy25vzpf03hc4cp82k25y1icnh9mkw4rkghvr68s2";
  };

  patches = [
    ./rtt.patch
  ];

  nativeBuildInputs = [ which libtool automake autoconf git pkgconfig ];
  buildInputs = [ libftdi1 libusb1 hidapi ];

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [
    "--enable-jtag_vpi"
    "--enable-usb_blaster_libftdi"
    (lib.enableFeature (! stdenv.isDarwin) "amtjtagaccel")
    (lib.enableFeature (! stdenv.isDarwin) "gw16012")
    "--enable-presto_libftdi"
    "--enable-openjtag_ftdi"
    (lib.enableFeature (! stdenv.isDarwin) "oocd_trace")
    "--enable-buspirate"
    (lib.enableFeature stdenv.isLinux "sysfsgpio")
    "--enable-remote-bitbang"
  ];

  NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    "-Wno-implicit-fallthrough"
    "-Wno-format-truncation"
    "-Wno-format-overflow"
    "-Wno-error=tautological-compare"
    "-Wno-error=array-bounds"
    "-Wno-error=cpp"
  ]);

  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';

  meta = with lib; {
    description = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing";
    longDescription = ''
      OpenOCD provides on-chip programming and debugging support with a layered
      architecture of JTAG interface and TAP support, debug target support
      (e.g. ARM, MIPS), and flash chip drivers (e.g. CFI, NAND, etc.).  Several
      network interfaces are available for interactiving with OpenOCD: HTTP,
      telnet, TCL, and GDB.  The GDB server enables OpenOCD to function as a
      "remote target" for source-level debugging of embedded systems using the
      GNU GDB program.
    '';
    homepage = "http://openocd.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}

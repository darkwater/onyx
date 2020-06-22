{ rustPlatform, pkg-config, libusb1, rustfmt }:

rustPlatform.buildRustPackage {
  pname = "cargo-embed";
  version = "0.7.0";

  src = builtins.fetchGit {
    url = "https://github.com/probe-rs/cargo-embed";
  };

  buildInputs = [ pkg-config libusb1 rustfmt ];

  cargoSha256 = "1mkk7w6dlmw49kpq5109mghmrgfj7vpkbxc9f6jpcksrq01abwzm";
}

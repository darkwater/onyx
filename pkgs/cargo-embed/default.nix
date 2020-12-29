{ rustPlatform, pkg-config, libusb1, rustfmt }:

rustPlatform.buildRustPackage {
  pname = "cargo-embed";
  version = "0.7.0";

  src = builtins.fetchGit {
    url = "https://github.com/probe-rs/cargo-embed";
    rev = "8520b9484a0177797ea9ef4e97f8ed4b1be5d2d3";
  };

  buildInputs = [ pkg-config libusb1 rustfmt ];

  cargoSha256 = "1cd3s8yah8i1z4z286i67prvb1m2857kcjfhfp76zsbm6r4id3y8";
}

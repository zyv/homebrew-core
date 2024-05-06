class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https://github.com/hirosystems/chainhook"
  url "https://github.com/hirosystems/chainhook/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ccea19c9e81672ddb58cfda84cdd5d923cc26af422c2c1b81d9424125d85ba2d"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/chainhook.git", branch: "develop"

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "components/chainhook-cli")
  end

  test do
    pipe_output("#{bin}/chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath/"Chainhook.toml").read
  end
end

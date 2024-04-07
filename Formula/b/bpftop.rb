class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://github.com/Netflix/bpftop/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "caff70f97dcfe03bfb88deadd9aba949a035f1457990d48e34f23b0a77a3a097"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5c73ee50782c21012bb32782328a48961d3614fc9687215c695964a4d8c160bc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/bpftop 2>&1", 1)
    assert_match "Error: This program must be run as root", output
  end
end

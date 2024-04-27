class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://github.com/Netflix/bpftop/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "0d60f27f3e29ebf8cb199f4ae2f3a40611dc084bcaac786b66ee3e1733236f78"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae504a1b2ff8122e352559ae3cf77a97d9cb615f8ee45e34ce42d12cc2602dc3"
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

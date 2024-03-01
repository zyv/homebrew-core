class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://github.com/Netflix/bpftop/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "5a63eb4963fbde83969099434dee2d8408dde82e1bee6ff4c88f395f45934c3c"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc3d55fdd8ad8e953e06d61441173a6472182768f55d6d96764b1467fa037aca"
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

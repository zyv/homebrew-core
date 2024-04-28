class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "4d106d66d211f2bfaf876eb62c84d4b54664e1c2b47eb6138161d3c608c0bc5e"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "bb30d48382c4ba6dc5e79a8fa5c228c057acf5daeefc9f15b890b1a611fd2fb6"
    sha256 cellar: :any,                 ventura:      "3fd2c58eee26b0618a2c0532c578f2aaa5cd18de1dd6ad1ee428ab749609593f"
    sha256 cellar: :any,                 monterey:     "cb4553f58f5e686ca065860190eea22fbd48ee5639b47dc8b8f224d52c876587"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1afb6f73541e7467b64880b7a73fe2e12168620eb2c69b8d5342a0a3e35aebc6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end

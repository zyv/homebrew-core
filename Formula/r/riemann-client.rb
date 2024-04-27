class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  url "https://git.madhouse-project.org/algernon/riemann-c-client/archive/riemann-c-client-2.2.2.tar.gz"
  sha256 "468c2d6cb4095e581927005a1dab13656f5a9355e4c68a3a25fceb5c6798a72f"
  license "EUPL-1.2"
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7854bc14bd566d2dde42dc063099cfc65f32e76b19753d707c6b2d3b9c25c7cd"
    sha256 cellar: :any,                 arm64_ventura:  "6c8e5b2f98803a91ff957f0052c2f2ba4bbc276fb4116bb244c8179b0f3ac835"
    sha256 cellar: :any,                 arm64_monterey: "10c6ded8a26a5b556881b2dc045175c0c02fd5221c8fb79c58805f30c01c150d"
    sha256 cellar: :any,                 sonoma:         "7392770dda4b7a8a85ad01c6fff29755ebba6bf454569a452e0b179031a2ed20"
    sha256 cellar: :any,                 ventura:        "3cc09e98b21351ff7e33c35664467ffc1c2f7ddec512a3f4fed9aaa2b44b3717"
    sha256 cellar: :any,                 monterey:       "76fd317852de35fce96522105df18ef93ce9d58105f764c7d25715ebd14fadc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aedd6872a9056fc17d3defe1f0602b61653c0b6ebf698df90da0297be259dd4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}", "--with-tls=openssl"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end

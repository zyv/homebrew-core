class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  # See discussions in this issue: https://github.com/libyal/libewf/issues/127
  url "https://github.com/libyal/libewf-legacy/releases/download/20140816/libewf-20140816.tar.gz"
  sha256 "6b2d078fb3861679ba83942fea51e9e6029c37ec2ea0c37f5744256d6f7025a9"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:libewf[._-])?v?(\d+(?:\.\d+)*)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4978bb8c35db1a5afdccdcbe6096e5cc238f997e57c876ed4d65c35b43c9f590"
    sha256 cellar: :any,                 arm64_ventura:  "da80daa5311029657731b65502cf08528ea9e07d9a1476f2d0ad52ab64a7ef44"
    sha256 cellar: :any,                 arm64_monterey: "4262862d000d00848c271f78597302019a2cbac42d15cf341349b4c5129a57d7"
    sha256 cellar: :any,                 sonoma:         "03c5cb4c4a47f21153015fff5a0d7030ff285330dd53d0448e3c85db9ccea8df"
    sha256 cellar: :any,                 ventura:        "d8853dc665210bcdb12500dd2f444800e63bd2610bb74d79625fdb6dfa92574b"
    sha256 cellar: :any,                 monterey:       "5e8003f48fac93514179c0ddbaf3ac650d2483bc08479941271153c11f5ff044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49acfe78aa143e1f8aff65029ed62033c535257d52af3cf510f27e0694f5f7d4"
  end

  head do
    url "https://github.com/libyal/libewf.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end

class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.94.tar.gz"
  sha256 "46eb3bcc16eff63008ae2c3177765264b88627482bdb978fc3d10e34e9d52284"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b2cf6b210a43bcd124b0266806f4a0ed4ab805e42e32f58db0fe1aa621e2c93d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "gnutls"
  depends_on "libfuse@2"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "nettle"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end

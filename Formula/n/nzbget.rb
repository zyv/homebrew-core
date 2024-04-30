class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.0.tar.gz"
  sha256 "f8b66551b943f72442a0fb00d8872a0e9c92c829e63d6a74c35888b7cb658dca"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "0649d819375f569c4331c3f49ec7a52ee3f946a3023bfdced0b91061f851601b"
    sha256 cellar: :any,                 arm64_ventura:  "458da39e32a96030249c365b62769481f25689f74ee883ee51f75f258a686663"
    sha256 cellar: :any,                 arm64_monterey: "06a0bb3f22c5ab5b5e5be455957b4eae0566f938d1bbc88ec0dc090f67b41665"
    sha256 cellar: :any,                 arm64_big_sur:  "7047029f0decc4922b72b1fe4b1f73977c54e0397e57b95c99691ee0c9a6917c"
    sha256                               sonoma:         "d3aca70948c9bc778b0fa5510ef6150e9ce65cb140ff23b2d79d093264a66154"
    sha256                               ventura:        "f1a1f0b4e316c364beb0ad6d4c404b108118e3ba393872faed6cb251f9c32417"
    sha256                               monterey:       "d924d48be76662efacb4b68861fdbe470500265e416c1cd679a441673cfde99e"
    sha256                               big_sur:        "6b161f7f674c0b7cdf0282dd054723a2a859888dce1558277c17bd40b0985c15"
    sha256                               catalina:       "9b8a312da9d8cfa4c7259488ea548aae1b2766c92311f747ff3105b19693b936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fd679c775ee8595c57e5459cc0eba8802944aa7181a4548e6cc6ad0340ffb3"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # nzbget CMake build does not strip binary
    # must be removed in v25, tracking issue https://github.com/nzbgetcom/nzbget/issues/257
    system "strip", "build/nzbget"

    system "cmake", "--install", "build"

    # remove default nzbget.conf to prevent linking
    # must be removed in v25, tracking issue https://github.com/nzbgetcom/nzbget/issues/257
    rm prefix/"etc/nzbget.conf"

    if OS.mac?
      # Set upstream's recommended values for file systems without
      # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
      inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
      inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"
      # Update 7z cmd to match homebrew binary
      inreplace "nzbget.conf", "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin/"nzbget", "-c", HOMEBREW_PREFIX/"etc/nzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}/share/nzbget/nzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}/share/nzbget/webui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system "#{bin}/nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system "#{bin}/nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end

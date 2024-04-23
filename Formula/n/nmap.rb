class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.95.tar.bz2"
  sha256 "e14ab530e47b5afd88f1c8a2bac7f89cd8fe6b478e22d255c5b9bddb7a1c5778"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_sonoma:   "1b9eeffa4054c551cb3ec8836b7bb36cde79dc29fe1b124364a4904e9d8fd7be"
    sha256 arm64_ventura:  "f23fb19dd6412e024c52d587dcc1b956bf84a165f3eaa51ea9b984d951a7908e"
    sha256 arm64_monterey: "adc1672fa419d6959ddd06e4e35ada9965c06e4abc216815d48995e3a02c2210"
    sha256 sonoma:         "8e41e303c5e6ebe78c8d3a513a10f84c3a1a8b19196645d7eaaf87d062b33c34"
    sha256 ventura:        "8addf2970437c64bc4b1c2ba51095ea91a7d8e5e37f3f4f6e84a1e4cfa3a501c"
    sha256 monterey:       "ac3af3e67012cd71f560d58ac58ce41404e88a5a87f1680829a3f04278cca083"
    sha256 x86_64_linux:   "4766fbde7d94d190beaca72cee513fa5628909a26547a7734c0a27ffe33436f4"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    libpcap_path = if OS.mac?
      MacOS.sdk_path/"usr/"
    else
      Formula["libpcap"].opt_prefix
    end

    args = %W[
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre2"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-libpcap=#{libpcap_path}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args, *std_configure_args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
    return unless (bin/"ndiff").exist? # Needs Python

    # We can't use `rewrite_shebang` here because `detected_python_shebang` only works
    # for shebangs that start with `/usr/bin`, but the shebang we want to replace
    # might start with `/Applications` (for the `python3` inside Xcode.app).
    inreplace bin/"ndiff", %r{\A#!.*/python(\d+(\.\d+)?)?$}, "#!/usr/bin/env python3"
  end

  def caveats
    on_macos do
      <<~EOS
        If using `ndiff` returns an error about not being able to import the ndiff module, try:
          chmod go-w #{HOMEBREW_CELLAR}
      EOS
    end
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end

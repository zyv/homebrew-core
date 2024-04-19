class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.7.0/syslog-ng-4.7.0.tar.gz"
  sha256 "b601265362c633a25f26c497a7e57592739d5a583b7963b722ff58f01b853506"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "dd5a93f7c7a210373ddbc808eb60425539068c73da3798d41c41b45c3ea11e6f"
    sha256 arm64_ventura:  "0f7706621aed4b1cdb3947b66f69df9c80e96372a1f7b6721ec1b86ba15760d5"
    sha256 arm64_monterey: "8ad186a0e9c0421609e3a3a51a03326598d045d0134e4d23be3f709159336f61"
    sha256 sonoma:         "2394cc3c5f2d6770ddab0f8f8d30f9ced1e32f07742e0aa492442a189c14dfaa"
    sha256 ventura:        "596d0062f0dbf83a53fa2236412d889e0aa846acfbceb1b2a225b09fccc7615f"
    sha256 monterey:       "d1b998e16010105264f1aa9c537ba4c76b77a8e216e8195ff2b3f42543b03fda"
    sha256 x86_64_linux:   "0b34b8a901ed9d3220b20e3d9ed577b5dfccbe6cc22709140715880a297f14e1"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    # In file included from /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/c++/v1/compare:157:
    # ./version:1:1: error: expected unqualified-id
    rm "VERSION"
    ENV["VERSION"] = version

    python3 = "python3.12"
    sng_python_ver = Language::Python.major_minor_version python3

    venv_path = libexec/"python-venv"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib/"syslog-ng/python/requirements.txt"
    venv = virtualenv_create(venv_path, python3)
    venv.pip_install requirements.read.gsub(/#.*$/, "")
    cp requirements, venv_path
  end

  test do
    assert_equal "syslog-ng #{version.major} (#{version})",
                 shell_output("#{sbin}/syslog-ng --version").lines.first.chomp
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end

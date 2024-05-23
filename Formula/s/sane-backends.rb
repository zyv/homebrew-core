class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/83bdbb6c9a115184c2d48f1fdc6847db/sane-backends-1.3.1.tar.gz"
  sha256 "aa82f76f409b88f8ea9793d4771fce01254d9b6549ec84d6295b8f59a3879a0c"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1851ff0ff04d2bc4fba4813d273b5da3b8568b319d125e281c87a727f931dd31"
    sha256 arm64_ventura:  "fb030d64b3e6974586384b4398b4652a109dfb5723e21fc4e237170d59870392"
    sha256 arm64_monterey: "dde5b1ae3dba8beba083c3adff88626792e0ca4b68f2eaddfd445122fa06e561"
    sha256 arm64_big_sur:  "816f955ec13f1767fa9bf3e721a3fb55a06bd17482c3db58fca4dab8c1a0ea44"
    sha256 sonoma:         "5e795e1714fc046087166763fc705461e0884dc53c5f374cc69bd67296123b97"
    sha256 ventura:        "dd313349947d2636690227b64fcaf52d17b9389851787906f37bf91351076775"
    sha256 monterey:       "0de46efc5c9fdfb44ee043fff93b630b88cb678de1cda40d62c30575d7979435"
    sha256 big_sur:        "68a5dadc176006ccaac9957884dfa582bde20c846e0567201efb381e5cc190af"
    sha256 x86_64_linux:   "d015337c002f86128e3af57eb58afdc40ad8716fdde860c60c939cc803245117"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "systemd"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end

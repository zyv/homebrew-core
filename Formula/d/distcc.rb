class Distcc < Formula
  include Language::Python::Virtualenv

  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.4/distcc-3.4.tar.gz"
  sha256 "2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/distcc/distcc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "f5cffa740e019ecb9464d09feda348769cba918566dce0f279584e92a8b4d16a"
    sha256 arm64_ventura:  "a05b3f4d6f2a93b71f087fac1c5e874c0eef2e01f6948d21953bf0056b2d2686"
    sha256 arm64_monterey: "c004a1e0a47b7fe7bba7e2dd6c730f962cc2dd0f3004f948ed6eb9d0948a5cf3"
    sha256 sonoma:         "f80d67bb32b6b555a17b6ef87e14520f3b37b4193911a1529a718d1d41f4cf68"
    sha256 ventura:        "9235d3dc9673e104ccaf44a575d48a6a8e467e724381703fb2451c4473488787"
    sha256 monterey:       "54f7ff487afded94b517b80b63806d285c447f9f4bf7165e7b7314b12325b0ef"
    sha256 x86_64_linux:   "afcb3e0911ffdb494af0fb80013de9c990690812e86f77001dde497ee0966b79"
  end

  depends_on "python@3.12"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20210106.orig.tar.xz"
    sha256 "9df153d69914c0f5a9145e0abbb248e72feebab6777c712a30f1c3b8c19047d4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  # Python 3.10+ compatibility
  patch do
    url "https://github.com/distcc/distcc/commit/83e030a852daf1d4d8c906e46f86375d421b781e.patch?full_index=1"
    sha256 "d65097b7c13191e18699d3a9c7c9df5566bba100f8da84088aa4e49acf46b6a7"
  end

  # Switch from distutils to setuptools
  patch do
    url "https://github.com/distcc/distcc/commit/76873f8858bf5f32bda170fcdc1dfebb69de0e4b.patch?full_index=1"
    sha256 "611910551841854755b06d2cac1dc204f7aaf8c495a5efda83ae4a1ef477d588"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.12")
    site_packages = prefix/Language::Python.site_packages(python3)

    build_venv = virtualenv_create(buildpath/"venv", python3)
    build_venv.pip_install resource("setuptools")
    ENV.prepend_create_path "PYTHONPATH", build_venv.site_packages

    # While libiberty recommends that packages vendor libiberty into their own source,
    # distcc wants to have a package manager-installed version.
    # Rather than make a package for a floating package like this, let's just
    # make it a resource.
    resource("libiberty").stage do
      system "./libiberty/configure", "--prefix=#{buildpath}", "--enable-install-libiberty"
      system "make", "install"
    end
    ENV.append "CPPFLAGS", "-I#{buildpath}/include"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "Makefile.in", '--root="$$DESTDIR"', "--install-lib='#{site_packages}'"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  service do
    run [opt_bin/"distccd", "--allow=192.168.0.1/24"]
    keep_alive true
    working_dir opt_prefix
  end

  test do
    system bin/"distcc", "--version"

    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS
    assert_match "distcc hosts list does not contain any hosts", shell_output("#{bin}/pump make 2>&1", 1)

    # `pump make` timeout on linux runner and is not reproducible, so only run this test for macOS runners
    return unless OS.mac?

    ENV["DISTCC_POTENTIAL_HOSTS"] = "localhost"
    assert_match "Homebrew\n", shell_output("#{bin}/pump make")
  end
end

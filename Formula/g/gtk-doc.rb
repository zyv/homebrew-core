class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.33/gtk-doc-1.33.2.tar.xz"
  sha256 "cc1b709a20eb030a278a1f9842a362e00402b7f834ae1df4c1998a723152bf43"
  license "GPL-2.0-or-later"
  revision 2

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, sonoma:         "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, ventura:        "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, monterey:       "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e6cd564005258dc7e144ead0eed77fe8564bf00ec7d628919534640fb6a50b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", *std_meson_args, "-Dtests=false", "-Dyelp_manual=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end

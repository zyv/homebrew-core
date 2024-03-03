class FontsEncodings < Formula
  desc "Font encoding tables for libfontenc"
  homepage "https://gitlab.freedesktop.org/xorg/font/encodings"
  url "https://www.x.org/archive/individual/font/encodings-1.1.0.tar.xz"
  sha256 "9ff13c621756cfa12e95f32ba48a5b23839e8f577d0048beda66c67dab4de975"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25349d15a665e08f3034aadd98d62e3c27c329c4e8d9577e9f7f067d65b23486"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c0127299540c1452cdb1849cdd5ba8b33eb24c9d79aa722aa21b64977c9fd9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0127299540c1452cdb1849cdd5ba8b33eb24c9d79aa722aa21b64977c9fd9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c0127299540c1452cdb1849cdd5ba8b33eb24c9d79aa722aa21b64977c9fd9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "25349d15a665e08f3034aadd98d62e3c27c329c4e8d9577e9f7f067d65b23486"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0127299540c1452cdb1849cdd5ba8b33eb24c9d79aa722aa21b64977c9fd9d"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0127299540c1452cdb1849cdd5ba8b33eb24c9d79aa722aa21b64977c9fd9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c0127299540c1452cdb1849cdd5ba8b33eb24c9d79aa722aa21b64977c9fd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f04de4d8394265ab50eb42d0e7b895547fd0032cc87d5180544e921c4487f44"
  end

  depends_on "font-util"   => :build
  depends_on "mkfontscale" => :build
  depends_on "util-macros" => :build

  def install
    configure_args = std_configure_args + %W[
      --with-fontrootdir=#{share}/fonts/X11
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate share/"fonts/X11/encodings/encodings.dir", :exist?
  end
end

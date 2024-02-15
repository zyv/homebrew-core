class Ski < Formula
  include Language::Python::Shebang

  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "http://www.catb.org/~esr/ski/ski-6.15.tar.gz"
  sha256 "aaff38e0f6a2c789f2c1281871ecc4d3f4e9b14f938a6d3bf914b4285bbdb748"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3579d8ff81a16c59efa672da26be95e006c19debd511d532f7fc29011cf02c9"
  end

  head do
    url "https://gitlab.com/esr/ski.git", branch: "master"
    depends_on "xmlto" => :build
  end

  uses_from_macos "python"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "make"
    end
    if OS.mac? && MacOS.version <= :mojave
      rw_info = python_shebang_rewrite_info("/usr/bin/env python")
      rewrite_shebang rw_info, "ski"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output("#{bin}/ski", "")
  end
end

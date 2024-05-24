class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.39.1/mk-configure-0.39.1.tar.gz"
  sha256 "538cd03343c682db3684d5e850af4fc51db4e30a09a0be9a8b4a3b1a5dea83e5"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b6b0504567d782b397108252732579d3ea8a4223f4c34be3d04baaadb14e8e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d333fa290595e6ccea5d4bafd31cc0547220e2cd8853fdd984f36a545f73e436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9acb780def12659ab21bbafd7fde77518f0e16291fab9946627bcf37fd9e216d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bd28e3afbee12c1b77a07e52139b56f138ecd37d0d9d61eb50ebcbc7fbbe427"
    sha256 cellar: :any_skip_relocation, ventura:        "4f60c94d99fb9244f4274a7faad34d1fec68d428d3f28eda5bf97b586fd49f64"
    sha256 cellar: :any_skip_relocation, monterey:       "abf80283e74610541fb9f88ec1c02a5692caa495067e526d814748cccd2d6ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "877bd2c89e9d2d6dbd8c4b4dcbf44202cbaf1dcd2088f2ff93fbc54d283d1d15"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end

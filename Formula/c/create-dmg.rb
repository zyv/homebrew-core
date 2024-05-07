class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "18e8dd7db06c9d6fb590c7877e1714b79b709f17d1d138bd65e4910cc82391bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1d0ce1a3da65fb140ef2740dd778066c9f26122f5fb58fd64f4200bb168fc85"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end

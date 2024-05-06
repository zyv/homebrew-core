class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.35.0",
      revision: "fd4df99170f5e9d7cf9aa8312aa8506e0e7a44e7"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8e8c03abf8411f909a910b72e91eec75c96435be7011806158d10b7d5991ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98ca219d2062f4501b0dc5821274ee57e93b357889709ed1b68e09c417c70658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2396d7736386e9b389da34e9667a20c84d42db627e0cd1435fb4a5ed552637d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "672d24b4160cff44cf0e7f0b90c3daeb9f19819eef33cfec6c703c9c4df81a85"
    sha256 cellar: :any_skip_relocation, ventura:        "ff7817850aeea5f48f6ad8767975527f07f0987688a2bbe25922efb100898b15"
    sha256 cellar: :any_skip_relocation, monterey:       "d99b27e850722229a9da7fd8f55a655dde4f5b920e03d3d660ecb4088b363613"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end

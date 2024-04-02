class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1160.6.tar.gz"
  sha256 "72e2d89bc7af55721408e0b79f7711ca18d3bc128c74dbe3c95049aae7a2f85d"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd228895b59ad7f66d3afdb9238092c0913515ad37c0207e1afbe6c50232fda6"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end

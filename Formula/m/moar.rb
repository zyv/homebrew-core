class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.13.tar.gz"
  sha256 "80c27ac2b1b4d2012e213b04dabe7395ef66ddfdda47a0c46fce0ec1533a5616"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "523df2d5ff6237d86edeeb87afb9edcbcf2d1da703f1a08b33f93773a01f2e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "523df2d5ff6237d86edeeb87afb9edcbcf2d1da703f1a08b33f93773a01f2e5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "523df2d5ff6237d86edeeb87afb9edcbcf2d1da703f1a08b33f93773a01f2e5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9005db588271e2e1a1582be0a8d9bfabf5c7530120120842d0b5ade3acf8a138"
    sha256 cellar: :any_skip_relocation, ventura:        "9005db588271e2e1a1582be0a8d9bfabf5c7530120120842d0b5ade3acf8a138"
    sha256 cellar: :any_skip_relocation, monterey:       "9005db588271e2e1a1582be0a8d9bfabf5c7530120120842d0b5ade3acf8a138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9ac8fa6c3e1a6534de9004e56a53e6b78e40a006f57a6e4452302cc688517c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end

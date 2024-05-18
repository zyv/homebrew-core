class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.15.tar.gz"
  sha256 "d2edfc143eb3c71ea1ce51753b60da19f907013a16649ff81cd42cb7e3b3835b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "675c785179bade43ae063f95027826b8aede32be339f2e263e6c87c3ce1cde92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "675c785179bade43ae063f95027826b8aede32be339f2e263e6c87c3ce1cde92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "675c785179bade43ae063f95027826b8aede32be339f2e263e6c87c3ce1cde92"
    sha256 cellar: :any_skip_relocation, sonoma:         "9726f8a7e468a07984abcb6280e74176e9defb35f30bd346f14cd8d391b659a9"
    sha256 cellar: :any_skip_relocation, ventura:        "9726f8a7e468a07984abcb6280e74176e9defb35f30bd346f14cd8d391b659a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9726f8a7e468a07984abcb6280e74176e9defb35f30bd346f14cd8d391b659a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2d3f700620d1e350cf0dc90f70832c40746f1e6c4f62f8f049e545c8fe26da8"
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

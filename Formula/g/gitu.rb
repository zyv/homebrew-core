class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "6b6a3811bff0aa60301ba82b437bc9b17985bbf82911d2f5d911f7e25219d23f"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4238afacedad281fa1921392692b475cfa7aaa41d78a559f09a8a7db54b13358"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e2d89e604183870b0d51b462f56085c9cb43f770378890ed1f3d5518350bc72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c78e57d07c04aecd6549a5adc5881bda702950fc1b49e3ef9265de5edd589ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8c46dd493857125f1c649065bf42489ccd6597aee0edd7cdb2d12c971478125"
    sha256 cellar: :any_skip_relocation, ventura:        "62f210c87398f6d3c077ba75e4cdbfae021e90c211c25dab9005cc0bf504ba77"
    sha256 cellar: :any_skip_relocation, monterey:       "802b4afa2d2d71dc6836fc56ce8ffbeb13ec32676b3ecaf0fd4a3f23190c3bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f71546934dbdd9f7ee41811148deaacb67011355694fffbc03afa9a80eecce"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end

class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "f36401daf3800ab1b52a0c07926262bae8e23b0e6c497a9d5077ae50022e6322"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da1d42be591c335b31cb581c2fd9422ef83fbd50e6c789852437a4ef7d2643de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9112c20431d625fbcb98854ce03e1490ef46c350c8e06f6fbf2069fe7ebb23a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb6d852519580c9f14544da89f84577e81494d4d5bf921d82b6abd80de0ed5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd5513114674cd4e8119991f051b9e5a2c7acd696b17d6808280599d98275cea"
    sha256 cellar: :any_skip_relocation, ventura:        "c6bfac05f4ce1c19349c85910e3fb97f5f58e696311a27a2d6d4150392a9f7ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ff01bdca8f5a4c43901a748b90943873d042d57acf6a0e076b01ce06ae176b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0edfc6d7024c8c62d2370b23be2c87a1339c8dc5713e940401c22936727348"
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

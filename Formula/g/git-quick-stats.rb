class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/refs/tags/2.5.6.tar.gz"
  sha256 "ddb2552cfbf605bd934c0d570ca2d0e77bd32f8d1ff706af1d3ac96dcf612ab7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef6bdf39b4e308fe136a6fb7a2dadda85218aee7be2509ab5b652cf2f2dbbc11"
  end

  on_macos do
    depends_on "coreutils"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?

    system "git", "init", "--initial-branch=master"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end

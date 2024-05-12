class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "452bcf23661780c10d53a28740079f54757cdcee47b0c0e15c77e3db6e13a641"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e8f506011b2018964103df5bb5d8f52f733f6cc7203eb95f3700eaae70ed43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2611d7f4126cb4fb5d72e9d79ce7369bf0a18e2b1c352f4722429a555f3c7a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa926d6db500831a2c78ddbc7ceb294d1b8a31132bbc022037a45186c07e11fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b25bb03be0bf2ab4fe7627ff5547e6b51d3804d8999fc66952417e02edcb6ff4"
    sha256 cellar: :any_skip_relocation, ventura:        "de94d7bfcd05f3675073800b7c0bcb8ce12ab262844afa47f821d593f063ee79"
    sha256 cellar: :any_skip_relocation, monterey:       "19f4c52bb6c4def5568cbde57c1fe93d13337a6c95ed94f3fce1f0a5e3066dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ded78f6fa20964f5a5370279f374e84c79ca42e1328772d78c2589e68fec18"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end

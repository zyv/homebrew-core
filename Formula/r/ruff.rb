class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "12dd075410eb8c73865048817d851fed617e0d8baa30d06707b8b67ff25e247e"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "269e89caba0feb20fd02fa83fddc53a62a05937f078b54a7e8e1f2d78e561642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e394a66607a0194ebac6e211e67855a0b013bf153a0df37221395d5a34168d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdaa398d2afd1a5e6e3473851ccceefc255ec640539123d3a1881f13d6bd2c0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bd6fd6e9d9ca763d3edf7c45981981dbcc26a1e2f4674034cd4989a81beabab"
    sha256 cellar: :any_skip_relocation, ventura:        "3b682c38dfa611489d0fc294db78a545dabf55443c91ffd5e16d145018a15bb6"
    sha256 cellar: :any_skip_relocation, monterey:       "aac92767349e98e3323573ccbcca33f0337a8878dfb66341187e600d824e45ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcf29328bc11357485a964bedf98718f8f7cc751032c86decb57b536c5902b4a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end

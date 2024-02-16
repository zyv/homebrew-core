class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker.git",
      tag:      "v0.16.0",
      revision: "6fac285015b6e07bc8eacc020d3f3f270c0bfe2c"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/Homebrew/brew")
    assert_match "0/0 new matches", output
  end
end

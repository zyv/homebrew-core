class Sigi < Formula
  desc "Organizing tool for terminal lovers that hate organizing"
  homepage "https://sigi-cli.org"
  url "https://github.com/sigi-cli/sigi/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "8bd08b8fb372cf0bcefd45275f8a6956d0f551e9c940c8724f55770ef5b79612"
  license "GPL-2.0-only"
  head "https://github.com/sigi-cli/sigi.git", branch: "core"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "sigi.1"
  end

  test do
    system "#{bin}/sigi", "-st", "_brew_test", "push", "Hello World"
    assert_equal "Hello World", shell_output("#{bin}/sigi -qt _brew_test pop").strip
  end
end

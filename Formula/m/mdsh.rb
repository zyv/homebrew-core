class Mdsh < Formula
  desc "Markdown shell pre-processor"
  homepage "https://zimbatm.github.io/mdsh/"
  url "https://github.com/zimbatm/mdsh/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "987fc01340b2d80029e7a1dca073cca4e7c8eb53a8eb980e8c2919833de63179"
  license "MIT"
  head "https://github.com/zimbatm/mdsh.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"README.md").write "`$ seq 4 | sort -r`"
    system bin/"mdsh"
    assert_equal <<~EOS.strip, (testpath/"README.md").read
      `$ seq 4 | sort -r`

      ```
      4
      3
      2
      1
      ```
    EOS

    assert_match version.to_s, shell_output("#{bin}/mdsh --version")
  end
end

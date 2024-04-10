class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8d05016b392fa43a33d6989c1f6e568f0d8b5d8893faf8622d02d36fd2d5e9db"
  license "AGPL-3.0-or-later"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Run the `lexido` command and ensure it outputs the expected error message
    output = shell_output("#{bin}/lexido -l 2>&1", 1)
    assert_match "Error initializing ollama: ollama not installed on system,", output
    assert_match "please install it first using the guide on", output
    assert_match "https://github.com/micr0-dev/lexido?tab=readme-ov-file#running-locally", output
  end
end

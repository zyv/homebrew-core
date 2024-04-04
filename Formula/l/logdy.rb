class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  # Switch to github source tarball on the next release
  url "https://github.com/logdyhq/logdy-core/releases/download/v0.9.0/logdy-core.tar.gz"
  sha256 "bd55b3cd380117288112403a19f4e7deeffc667df8970425c5e1ce8b87848720"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}/logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end

class Rustcat < Formula
  desc "Modern Port listener and Reverse shell"
  homepage "https://github.com/robiot/rustcat"
  url "https://github.com/robiot/rustcat/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "59648e51ab41e4aeb825174dfbb53710207257feb3757521be98ed28c4249922"
  license "GPL-3.0-only"
  head "https://github.com/robiot/rustcat.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    r, _, pid = PTY.spawn("#{bin}/rcat listen #{port}")
    output = r.readline.gsub(/\e\[[0-9;]*m/, "")
    assert_match "info: Listening on 0.0.0.0:#{port}", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

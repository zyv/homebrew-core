class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2460f8c5f825e63e365956a25e806ba28ffdb5ebca05046e9932985ecda84c1d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"flawz --version")

    require "pty"
    PTY.spawn(bin/"flawz", "--url", "https://nvd.nist.gov/feeds/json/cve/1.1") do |r, _w, _pid|
      assert_match "Syncing CVE Data", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end

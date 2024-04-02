class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "fc962e3acbedfad63934eda016d4e380dd3a06b4636f2b1e61ade9700a2addcd"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags: "-X github.com/navidrome/navidrome/consts.gitTag=v#{version} -X github.com/navidrome/navidrome/consts.gitSha=source_archive"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = fork do
      exec bin/"navidrome", "--port", port.to_s
    end
    sleep 5
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

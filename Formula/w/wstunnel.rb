class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.4.1.tar.gz"
  sha256 "4362bb70883404f6ab78a82c862be3542718cca711807ad0d86acec629615b3f"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f860c2d82926faf6cb7384a8c4796f3438eaa5052e32b8265c7d86b9cf98552"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20d21dd46093db8183ef95d0da0b0bbda869fde70c8b3193afd471704eb6f48b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548a6e660f985bf6f20ea5048688681f5548ccd4778a8b8907790fbb7fb81206"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e51ec30c0a37aab8db5c94f065341482440afafb5492a6b90d7a325b520054f"
    sha256 cellar: :any_skip_relocation, ventura:        "618c6d7e9df87736b31251a89f44b5fe976e988afa4d5f8a270bde955527e618"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa2ebac83e028af2ecb32beb899ce5d2190a62aeb188a767e942ee5ecd4498a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a72a8702103b242ec397ab636ca961361f2c529a8e4c1e2683e2f5a6af83c5e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port

    pid = fork { exec bin/"wstunnel", "server", "ws://[::]:#{port}" }
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end

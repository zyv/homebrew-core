class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.5.1.tar.gz"
  sha256 "6451fe1cf4c7f9f6a990cea447359d4d2fee92e434d414edd48dc8345786efb2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe747e5b52edad02aecace1f9335a855821e19c86b5dae3cdd07a6155e42e111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b824fcf5a59ec238c7ce953358bc5a3eb1d4355586628eb524a1a81894273fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c0dea903130cde853e8e4cc3bab0d1abc14274d491c0c34c03d4de3f288c19"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0c0e16065de422e90b961feb78d9a86125a42f0cb3d8a9f205cca0b73e3114a"
    sha256 cellar: :any_skip_relocation, ventura:        "eea498e20a9c828f71bfeec4ed3f5fe8e90b71ef69c131370eb10fe0b9b6b3f2"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4fb9e3f5f3d6be889034fd2e1d8b1a3be9f579129edc2e5aa083469a51f2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144c21713e1486d431253d4d2efd916c5d27a1a9b0849276e04acfd354dcb481"
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

class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.36",
      revision: "92ca2cca954e590abe5eecb0a87fa13cec83b0e1"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0da7e2b7ca44186f76a2f9bdfe4a7739089c88e148a6aa4f199422367f0d8ab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a438278b91c9aabb7c7982b005e278e6d9c08c46d7bce105443b1acc41e1859c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2a0f965f600e43842f9bec4aed6e26141e674eb8056464a59160cec7c21a5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c6397515b310128ff757706ee687c5b502cb8ff758d96406642e7ce8c4f7b0"
    sha256 cellar: :any_skip_relocation, ventura:        "6b251bbbb590b5a7a0cfe8fb3e356dd877af8cd5e02ae5e176dea5e83460d2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "1354fb134f6b3d93ddc22682b168fe27c946bdd4c7fb7e04dfb2c33fa31c31b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54a32f0267446473afbd78c1f1c7bdf77a361a809bc3982c152a25cfd8c0f28"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "version/version.go", /var Version string = "[\d.]+"/, "var Version string = \"#{version}\""

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end

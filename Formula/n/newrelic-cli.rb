class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.78.13.tar.gz"
  sha256 "e8ace4a2508a5d91210b68380e39d12604ba49f9a6a1faa5f28e1fc97e1b261a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de956556a5e2f1aa88d65fca04b2dc0ada3d696fadd71f4b9404471a943c267f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a120e0f1fab67413d3a71b56f8cbf5223f57b60eb37df10db77e5a449c20750e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bef90e0c8d26570fb525719f842a712c357707becdd94f58281763d64edff4b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e55dbc17c0733bf54ccc04f4598cb9fbd89f0c9a194aeeb6f603f4f61c361923"
    sha256 cellar: :any_skip_relocation, ventura:        "821cae2913e0ca035a34efc4fb2ab8309468ebac83be9ce196ca4e221288bac4"
    sha256 cellar: :any_skip_relocation, monterey:       "c1dcc029d1849b5da916a8d40c039043d927c191bd18754bd1b001df48642649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92225c5d938596694d99c5e7eca6181b6bc15d8b8d51075d0bae87f902f79b7"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

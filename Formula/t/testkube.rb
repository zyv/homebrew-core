class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.41.tar.gz"
  sha256 "90d397aa10520b9457b08d11f5952629e7933f9f4ce029d360835da861b08b0a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a32a1bf5b30592616d1cf01edcb8fbd902d73f7fe05b788445c50e4eda75de49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f2cd99c2538b69a5a13c636510ca244bd71f7a9803fdda4230b969b45f4935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a179084d3860db02c03cb54d6972919bf2985f6a74a79636a35466dc47a77ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "239e802119e8757e841ef0298d8e3c52b9737b2668f988894bc175fbe850cada"
    sha256 cellar: :any_skip_relocation, ventura:        "8fcf00d20d451f03854da5f492c7ea47958a59cdcfa26e283e6cad462f190862"
    sha256 cellar: :any_skip_relocation, monterey:       "7d24b692e67526bdbbe85771989c45dd7dcc914c78684972b21c3d620dfa78e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7063e48ab8064da870311031ef201a3b4b11578db5a9a86571002dfea86a35b6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

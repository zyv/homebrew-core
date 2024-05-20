class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.39.tar.gz"
  sha256 "d00b4d42e43f3338933b43af3c20dc4eb58c895df2947b05b732204512e33f49"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dd4a04c5e85a270bfaf9218fb1ff14defca45085e6700b6b255bae7f9db1995"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8992633860ba5db2bdac9bd50ba03cf7c794a62edd3432131be7186b1f604af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd524801109d03e2dc571cbd56bd6d1db5ef84fc0eb5ba102c5c979990f19eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c385de331940565f32d0eee7bef5f49e64901c6362009e6ffdefc9a7f0c8fab"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2f25276209c547f1b7d04916379a2e56fbacb10517027c6758b9a45e898a06"
    sha256 cellar: :any_skip_relocation, monterey:       "35976e5593d283323e341ae3ac1fd12daadaa8991c8079900581f572495c4c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164a4b019a1e417e990c8f6575692986a7cf09cdf1ecac2f9e751b81dda8d4d5"
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

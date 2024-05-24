class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.47.tar.gz"
  sha256 "628556a2cdbad4e81886d1ec37735cbe030986a0e2e3fdecd0075b17ce1e3aee"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ea864c1ecaa5bd2797e569ea37af7cbd60fd438347cb325b763c02426ee12bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1dfadfd470266d2c6d5109d07a1f0120521a008c901448d6ff166fb801eafc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8ae19539b2e27a4caaca6d1ecc225fbbf31fb1a36c5ced7e4889655705afaf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b03c3d1c15cbdc90ff498a1e1794d3d8a768081775149f6868fa6e4306aeb3d"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b3b4f0178f053eb6544c8189d56bdedc595334aaf8fa58920cc99df42d8997"
    sha256 cellar: :any_skip_relocation, monterey:       "022e2f206c5861cf83965758783cffddd5464d226ebd64cc02ccf02970d34542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8942621bb38a2a949969acff87181048e979f03245219b4afc41a859d8648b2"
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

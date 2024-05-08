class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.25.tar.gz"
  sha256 "2d8b69506b78577fca6cff23cbef8b5d22700b0305e61c9d7dbecb7dc952036e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2d681cb85a7fc8fae20ddd639cfed62fbd1a887ca76338d9b4017dc2ce2d889"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393f0bf7275a96ba592127254bc3dc851a59ca256a75074b122242aaf8b0f471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d094f6f9a666c509a97fcd040eed800e4997f13351df7729c36557a1bf25520"
    sha256 cellar: :any_skip_relocation, sonoma:         "d96f49d129ee9e9641a8b7fd709ab5fa7279c154ffd0619cb3a2dc7b1f97dc1a"
    sha256 cellar: :any_skip_relocation, ventura:        "729313f5a96fdf41ebb0940356e8df37c40ba580e06380bf325b6261b29e5f23"
    sha256 cellar: :any_skip_relocation, monterey:       "06126c1ed054b7ce7f1baf33e17baaa92886d43fe96a455bf3403e454d402ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79eb8b808593450e45cd0ecf040cb29b6f565640c926aa14820421f5cecf568"
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

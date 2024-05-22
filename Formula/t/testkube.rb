class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.43.tar.gz"
  sha256 "a0fe6f69b2583f346b6b34fc68c58f62017e495a8bc90b393e28d6c098803942"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82a57ad35013774db1d58e8223afa2c9c9ee1ef47064b38035aed663863e1a84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51182407d1ecc013a3cba73d743ae14cf5568864d4cff58b22e6b965cd11b1c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7b339d5703e57e1acfa71e3a95b422adaae1c82ebb28f5e6597cb0096a65de4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f2a42fafe21d435bf42f737622df3495e7f07439fde498a1ddc04866db517e5"
    sha256 cellar: :any_skip_relocation, ventura:        "8980cebe90f1a3d65c407bf1c1b0ca49e7c57990141af24d35776c71dbfb2ad3"
    sha256 cellar: :any_skip_relocation, monterey:       "1759b39a3422258a735f0a841b5eaa61f00312cc07fc049c279fbf852784e73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9834d11ab0f2e3179445253edfa1649307d88c37e8da2ae9e0ea337e87cb489"
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

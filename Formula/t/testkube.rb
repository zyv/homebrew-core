class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.48.tar.gz"
  sha256 "2f7acdc162ea412759a2a27df75f56e9a3b8eebe0e13e7bb5389ead394b906a8"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fc20bd648f55a791fc3d334b42c6b9ecca6365bf33925b6e745450fe733710d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e1eac4a57407365e40cc28c06f31c89e5677f254d94987007ddfb45080f1237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9365b9ad0fb795550b4cb8b341be57822bb7ed70394b8a8ca6c02d5a328dd4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8973affffb0845fe450b984f2e6dc5f1fbf9c4f68c8fec395b17fdc2048ec593"
    sha256 cellar: :any_skip_relocation, ventura:        "d66eb900c6c2bed9d227c20ac53d747487b558d7d488b0a862e974c9241a9004"
    sha256 cellar: :any_skip_relocation, monterey:       "a871ddd727fbcc2ff9f162f37a0dc68e68ab3bf9db7b169a2e20bcfebcc47281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe17f874ca4d092325bdcad788cfe6e5724f23ed3f10ef7c293c29945b94505"
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

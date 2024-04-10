class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.13.tar.gz"
  sha256 "3c46627005f86ac3ca13971910ebfff25b7325dbefa36ac85452ea6dcef1c977"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "784a7c56f4a2a4cba88d9b728dd045e638e3958d5f7ddcc99f1026942fa42ac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a8a2bf2a8da8f197e6e64623961832f01e21ce58e591f9f764ad7a4a80b2fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03326f885e7e493ab31c3a8fde20ec7c4fdfcccae50dfb6f436090addea59798"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e231d1a625b66ab749368de096c5cae7e0188ca27abbbde2e6d666434c51e3b"
    sha256 cellar: :any_skip_relocation, ventura:        "bba9e8f61f6e22f311161f9d073878617bf2b1710e051cba126f4f8f511439a1"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e8f80be77953ea64896fc96f6a26bf0d6d58074ed7fb91a7b3d1ec2cafbe2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3611e407734031f4f24998a7e01d27772ba8ad8975207dac6c3d6a2eebca61f8"
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

class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.4",
      revision: "55019c83b0fd51ef4ced8c29eec2c4847f896e74"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9cd2d4d420705c5b8f3d11451ef758f26bc8bb7c314a2552b81a9d57b94b43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f99c9d15128f88bd360f2d5139c8641a12617a4b918ae95c05581cf23f1262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e83411c6a89da8a3046bc5f4d741c9d5131b2fa99c12a6529e9d753b5e311d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d926acff8e4f97994e194361a5e53192e723d776cf9ce3b0222e85b1c83e4e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "e23eb9a4574cae0111d93f39345faa15a7b5199c3260bf4b375e3cc4d7db007a"
    sha256 cellar: :any_skip_relocation, monterey:       "056cdce508ab8f8b39efa66e10bf95814b3ae4fdd8e9462cbeac71b04b887233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba80b9b71202e11a1785fbbfe0a76bc459a8ae44cec099f4c77ce493aa650c0c"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end

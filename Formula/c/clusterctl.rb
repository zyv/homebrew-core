class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.6.4",
      revision: "36c0e55594d4c99b87acb2ee3dccd336c8bb3f81"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "216d4b1058a4051c756458b926d4797732145ab0b75338553bd095f863437d82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdf1129d61d22afd0e015ccd2bf6ec8968fd2c22669c1ff1d19df4394e23e530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3714933fe33e2677e4771a2081fc9491a373a49223ffbc26ee7432c24572951f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e0ebfaa5819f92b529224f1e825b1266f48cad431a8b009c5d4aae0bc7319cf"
    sha256 cellar: :any_skip_relocation, ventura:        "7d9929d838ea70aba9429686ea88a2903d933ab28e26ce200a75521ff0cd2585"
    sha256 cellar: :any_skip_relocation, monterey:       "7af6782163d3b1a3dea2ee07348319e4d6c6ca1c8fd5d7d3e25f67a286d9dccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d684a9f82f94d919f419b8540933118f9bdc472060c90130dbf7be3ec813fded"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end

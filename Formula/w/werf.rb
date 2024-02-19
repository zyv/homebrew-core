class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.293.tar.gz"
  sha256 "563fa9effd660feff8a115544a3088024138788019f211948ab01f30b3dfac4f"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff0d43d80ee69702dd593f0eadc6baa92deca03357409de132b15e22e77d188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05c56f307a77bdfe66a8cd041f10d4456362b156009141e7cfe3af09905b52d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20089c414d3dc044d403d27e6dfff0a07e858cbb2b68a59862fc8b6c521b5bfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "81b02f705adc05c5831edc778c618afccc98ade6cfa2c26000ef2da523de8cbd"
    sha256 cellar: :any_skip_relocation, ventura:        "5b105292f0520e90a1de808c1938a43f47b29e05eca6871751dfb16e17e8d373"
    sha256 cellar: :any_skip_relocation, monterey:       "5d29d9564f820136ef6f5451c20f7645d7ec36f30dc944bbfa74d8dc68826030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aff4f9f3854cb979e2f2a1290fe9caaef88df5e1140e7d4ef07ed044a79fb25"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end

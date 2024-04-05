class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.305.tar.gz"
  sha256 "f9890c536a4cbc0097da10a076e5170327bac4f32f8ef33b86f5ae7fd5cd01b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e335f295f93d627240e21522b93dbf318158559d559537c8d444aa90a0a8bb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "577d5fe79fee12fa71f46a5a15580a822be9a3fce0ed0fd9a112c664ed8723a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64f5f2c7f3f7d2e8df792139e83c69ef0941eb6115bdedd557010162e34e4a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "03a9aa22703ab857e77308fa5207d631da51d7050469c7f24abb2bb43d7eeb52"
    sha256 cellar: :any_skip_relocation, ventura:        "b898d179db3a5480217fea3b940bf615bbb85a9e01c6a1877da018646fa52f47"
    sha256 cellar: :any_skip_relocation, monterey:       "216746379009408932430c88d06e7173895a33fc5ad22c39ff64dcb4c1d2c442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965205fe6ed80e40c76ed003339267552ffb1e66e078a3f12bc9be9c391983bd"
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

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

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

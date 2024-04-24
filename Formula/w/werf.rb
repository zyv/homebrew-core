class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "7373fa3d1dfdbe352ffeefbddbd9006e0396b2f0b35ed7b921044d9379430ce6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8d6c205feeb74f7b999bad5a2851a3ca054ff249b26fec2a6f482995070f572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6030608074def31ddfae122197b983840532ba5cd9b7ae05b791555dcc4836a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c8489b372e9b04d6333e4e382cf7508bfc0798d0e92ba8f0790480f469950d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b179cab27bef107616007ec9d692eaf8f4648530cf24b109194f51dc915f028"
    sha256 cellar: :any_skip_relocation, ventura:        "225f29bfd6a1980e1ac12b8142fb88e43f01ad03353870454baa5a9fb58dc5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f3afd43d1bcbf4fedc34eeab30465f7a88cb2f7699cd6a76765b27e79b5959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715db81b92c012a488a262089847b723d17a636f547b137892860383603f3e79"
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
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
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

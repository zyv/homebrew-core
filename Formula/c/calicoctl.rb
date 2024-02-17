class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.27.1",
      revision: "764c17872a5ad8aea1853176dd6df06b9240e41f"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "980872d225154ffa937dffc1f8995732366b426c24b184aaf744c1af3a50b146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc0587e8a175da22dd5f96e648d5ae879fd761317afcafdd37735ccd0d2a937d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e32f1cb105b180fb550ca9d4500a64a0413c9aee0e449a3ce3d840bbb8ab51"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b0e0d33e12e599f9b0892d2b55f9b003e34de5ff04709f60c736cac454f3560"
    sha256 cellar: :any_skip_relocation, ventura:        "db304d59a6c1c9527cc3a969b1230451fb05caf03ab9c9f1df6764ae6017f8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "63f107541b9035c894bda2abd5119e9ac0008dec5300679e15ed4812a8607597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd5ed9dad631dcacca33bc24dd97840dd548906e56f61b7812f5cdd14f7e0bb"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end

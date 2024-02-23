class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.46.1",
      revision: "8b7feb3a1c55b2f9c67d6df29f48747053200203"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba5afa1fec155d627c05ac2aab9bf5cfb07ba7c324ddfff2635db14c5ece8506"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b0574ea12317b57b15c8a7c30ccd23f492847a8c8ee80ce239dc0b770cd8add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be16fc1b331a08907bceb48fbea538432c0fa35e449c1ffe94f862f818451d36"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5870ace7130d94274e0e29373830236b72e3ff5dc38f1ea79c595873676a531"
    sha256 cellar: :any_skip_relocation, ventura:        "bbe5886986d18a164a46bd3ebd26db08ecaca99f2abc5baf7d8208057e05700f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d103744cf1fe7695cbc77c07264311caa91eb51aab8cd5b87ac71eb0a50d1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cebfc1823e39d15ac2574ab337cd26f1fd75880224f7455f89a0086be5a3584"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end

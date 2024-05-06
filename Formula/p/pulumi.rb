class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.115.2",
      revision: "95f06deccd0fc1d1bf04108a8a5ec1722e7bc039"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5b7de49be613030a65cfa4ebffa041c4b0bb6a150b163ed6713204091392dbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8152fe87c564573e323e17a813162853120250f979484f45f9e7e0a3195bfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f568db1f70578cb9c5a4eb2d8f39834a2c75ec91b79856bb28bd7bc3681d6641"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c124a239aeb0b50a336d2a07bb9a8e12c4ea232ba642793963bd465bf1eb708"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ffe4e9ea210f52e7da4c7f37def9a59dff008718457c6fa53206c75b2396ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a3fa97a36a4ed86cc02d22eceb48caf455180cd1f410962fff621b72e20d57bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19af6e43d3a458415025a4b55794a2e59483db39a070c45eee709b4e522ec53"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end

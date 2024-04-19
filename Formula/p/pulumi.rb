class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.113.2",
      revision: "5d73fc5b05032251ea045eeb3692eabc5e3bacf7"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f588c950c5979bda03c0cbcb145d9ceba2710a72f1b3667a1f966d471a3886b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4014d44be06bfb44fc982fdef33b8bbccc067e75e263fb4f3e43a56e07dd407b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d80dce30c04b607cff64b62e8a1877275b22fc5a3742e8bbbae1ccd475fc8c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "e42c0536ea5c4fa696d35e8551424dcce6b3473d27e3a7799af08733379ffd13"
    sha256 cellar: :any_skip_relocation, ventura:        "e2169cc7a4b4c57eb097600d7b8397090411421ea0e181cbe41745b4e1d22f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "dadf9c2a11e38c40d452668a94ceb60fb1a4ad0c871db22ee56fe6bae1611d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c27bab8b94470803d0d2bb7dfee5ae3fed71eb2a1171098202ec436517ffbb"
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

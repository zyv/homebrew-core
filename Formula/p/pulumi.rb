class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.108.1",
      revision: "697c8216ca0fd868c9232b4f7723198ecaa79f4e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cf2a9778d947c721fc8dce9a3b5bbb402c2f680c93bf0965584b142bad26fb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab810cd13ebeb14a81d9d83e44a049f12bc0abe7596db145c78e73010dfc5b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc13f819b59501338040572e06a8394e016d9c3bc7a5222e09f6c40c01e1573"
    sha256 cellar: :any_skip_relocation, sonoma:         "432c0ebe073106e0923d17370e528bf5180fe0f2ac78a8e6d5be875d2a3bdd9f"
    sha256 cellar: :any_skip_relocation, ventura:        "1345219f37ea873154ee8d873ade6180a54b77899ef8f9bba756c018d9046f2f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3b31aa70904fa5da8c42aa470231a33c0075be88d5de017ebda9238ede851a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7144d9be4866c312d4ae2d897a6b7ea8c7cb9a049b2126b1be9626a2382719"
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

class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.6.1.tar.gz"
  sha256 "8355cd74c675d4154696051318719f4fd62c190efffd49cd184a3f7743316d2a"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "810f3299009dae3e16c713bfeee9e3228a38ab75d6bb6590104bee7472eb1072"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d901c5b608f9b65d143c68d0f8dd2d6b43e508c3e0a18b9afadf1a2172d87593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcaafd2ec94b9934971b51304aa2cfce4c16c6ba62c6dbf5da00b42fad4a87b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e884c71d4eb8efcc28fd4f0c9f13d3fbd0d7d664f9b5cc29bf91de9227b2804"
    sha256 cellar: :any_skip_relocation, ventura:        "1afadefcb63587a0e9de1058eb32841e3e121b1f6a227d035b3afb9718120c45"
    sha256 cellar: :any_skip_relocation, monterey:       "55117e40f3d33cda1489e275a9b241ebe0a88b63a68adca6cbfe2a23d86a9ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aa4ad23f3b6e66fb100d1ca7ed5110c30f1dc716beb966a37ab6ac5bea60dab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end

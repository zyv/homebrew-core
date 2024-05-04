class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "e7caeeaafadbde56c18fc72bb6573b2bef6caa70b7a4ef7ebde73db0ca56211f"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed2a2ac77b2ce2cbe05e91c25dc135446a7e84467e6f340716607073bb7a3417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d519ca292560bf30bb319060d4a591a0c4f8d72cfc299231f79ff64a94a1ecc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "034c36e831143a83c22c4aa02ab6fd77c9bf73df37a368bd1b49368125076080"
    sha256 cellar: :any_skip_relocation, sonoma:         "59b07e4dc76c76e32aba9567dcfd1eb7407e63ead7cb7a0c88fcbdd7641b67b1"
    sha256 cellar: :any_skip_relocation, ventura:        "540d1cd388e221fbe7e20284dd84d3ea5d94f2d072d5fbf10519f82b8ca81a45"
    sha256 cellar: :any_skip_relocation, monterey:       "1c81321a45cd3496fc994d3a855c468749a47aa4b4a305c5c944ed7111dc8f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16eea01b08ee76bf443218d36a3f9791b0ea35b915dde2aa4a0b9fb74693eb95"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end

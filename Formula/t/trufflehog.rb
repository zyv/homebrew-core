class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.68.2.tar.gz"
  sha256 "f3dd504742cbe1730cca28be858a1b77c85077c67c3599be3b8a466825413c72"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcccd90c0a6132d9fc074a36d53bed483b51d368f19f5a7757551a7af42033ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f92f33d0cd0dfcc9ff9ceeedd8bf915d19ad975d68402fda4ae90347fb6b5b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "824eec6479b6255fb7af88ef5570ac9f536b340995d9c1de118dc73210d1abba"
    sha256 cellar: :any_skip_relocation, sonoma:         "774a55dfe07d4b1429adfa84ec808b06e1a987d65c466243e81cf0569a28482f"
    sha256 cellar: :any_skip_relocation, ventura:        "1f7cecaa3faf393c3894fb5a29110e1ddea15629f37cfbc6f8820219903cf1fb"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0aeff222e78dc1c65ef556ed4699010b8962d446230b91d06bc60e96908a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd21c9d5954cb5b2e2b771a6293b795a4507138384bcf83573861e1ff5c4cbeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

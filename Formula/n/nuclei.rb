class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "c3775afe13ca11d5640098b23d3725ab9e325872ce4c812b6c7acf6f96d2193b"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36d79c4527db8d2b7365b74439a59312d04efdd9b6ce5b441b9dfcb097b50280"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e654c8e00bc9e43ebcaf339de3780fb66c84fe90e76a2b2d06f505b1fed6cb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6678fd6af9f2981ae8b674fdb5a75e7b80d96e1b26934c2db0018071ebf96427"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7948968c52f9c392949841f8438948e82402365478c5fd9c564b1d3c992eae5"
    sha256 cellar: :any_skip_relocation, ventura:        "d8741e30be9501dd8ce4575d85ec9fe3191c71003165873af00814632b32dbdc"
    sha256 cellar: :any_skip_relocation, monterey:       "8db027a621c145e865a10d02db3579dbfc2ae29111cae6ea26e2eb42a9f18b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d27f31b0823eaf896257e6c9f0415a5409e5a65a0e8eb9376a24633de354e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end

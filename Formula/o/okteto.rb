class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.27.0.tar.gz"
  sha256 "16ef803b962d1ecafc414fbcfadb247366661c09b817f43aad69950e09851d5f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac37462b7ed42d2178ffbc03b835580d6fe3cc429473bfef00326bb15e9b27b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a6e141c2d3711257dc56e57266001d861bed300453b79e4784c0e9436fe1005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c30b84299340d3a1e5ea62e4085bc987ab3e46badd5217960d48e608ff09964"
    sha256 cellar: :any_skip_relocation, sonoma:         "735e5e5ad247d8fcdf801bb3b7267b9324fbd925029b52c79ebaa3df83293f13"
    sha256 cellar: :any_skip_relocation, ventura:        "e3bb867580c32b5b2330edccfca0f52cb1509ac3bc6621ea967f0f7589c709ed"
    sha256 cellar: :any_skip_relocation, monterey:       "340b3462082544a8d1a61022af0bb8f793d8ab6de15fabe0a30a0be14c26bbae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b5bd72815ca82d4ccbf741233d8cb41c9d877b05956a266643a06915872aca8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end

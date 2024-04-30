class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.84.2.tar.gz"
  sha256 "e9f27fd17d2b67a66d44a64b23f4395fb968bd8f5130df92177ee611770c4b68"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f8f31693162680e66fdfc9231fb9b485b2bbeb56ccaa59f2d15488fc0b85857"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5e6f3812ab0d1c91fafaae05bf154e45005d33060905b011dcff336cb01da1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41dfb15a28fff8f830be0690354a80ef3b9a1ff1b751077c9ad802f215b9a93c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b5148ca8cf6dd1fec471a02ef649a01bc22498e3585fb123b289dbaa66c22e1"
    sha256 cellar: :any_skip_relocation, ventura:        "9c4bdbe3b1dc90f60a951a2600795166c440cd65e8b69ee0cb9efd2607eb5cff"
    sha256 cellar: :any_skip_relocation, monterey:       "02ba163fa4960e9dc70bec53a12706f42312f918ea8ab133a9eaedfbd302b6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8131638ca2ee12367d82e18794ef38346e3bc6b264e7afb72e9401b43a8bf0d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

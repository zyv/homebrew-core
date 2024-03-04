class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "45c48c4b925efe8388523e4e2e73bbfb7508df8f1fd238c176698674954ea505"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9fa94711ba991b2c7e2d5bf9ef7e97e5a2bd0b502e552dfcf4919ec51abb8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcbf4238112a5eaf6ce664117bea4ce9f113e5dcd7a624a2ee4e00a086b011ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c51d5485b51c4cadfcc0697ad451f522733f3a694d12d1a2a71958e64db57c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "aebd79d16e4d86b4ab1b1a5768126cc61ac66617f180a9d3d723efcb07e3812e"
    sha256 cellar: :any_skip_relocation, ventura:        "bb2bc77f598aebc386664f238c04395b573b30324c0c935a34aa928302132aea"
    sha256 cellar: :any_skip_relocation, monterey:       "194a45d21ce7b179bed0d14d0f4737926d358e264eaf6f72a8185adc7decbc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d2af86a7dca5ff89fe9eeee7c67da0b4f7a82d06a8bba4448db3447660d6b54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [CNAME] [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -no-color -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end

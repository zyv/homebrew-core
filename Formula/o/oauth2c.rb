class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "6f2de82541aef816763d6458eea06ec93d788309d2563974931221a0e2cb4286"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adf7482bf4878de6be4b565c694305db011ddb3431ab01916a4df0d9a166e82b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d5892cdeebafff738bc7b0066a8ea29f25a886b99478151fa09ead5b6f5d2c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4263251f3c53acb9b631fc589833617cb2031228c024d2a774d37f70ad1877c"
    sha256 cellar: :any_skip_relocation, sonoma:         "927e208079445a4e8cbf5b60d447c1498f92ef79de0c9f92184a60954645b8f4"
    sha256 cellar: :any_skip_relocation, ventura:        "3ec37d27d8756e4bc4d52fc4737a8044a42614e35fe8dff171ba0b78c17c3d84"
    sha256 cellar: :any_skip_relocation, monterey:       "1e6e3dbf12650211722d69f574f14cfac241458df742667ffadacddb03b95ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e77999d0705e67d372c69525395b11d3e2768c1fe0d3a1754871592c7e78633f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "\"access_token\":",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end

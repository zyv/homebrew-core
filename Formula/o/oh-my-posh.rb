class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v20.2.3.tar.gz"
  sha256 "68b9f8050aa9b3ad4863567bce135929dff9444f0b8fa3d8f55defd4f69058b0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19eb3fe90881d2bf8366ee929f044e36e65e7a38f20e4669db8286468225d1b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de0d719f3b6dd1fd889d7d86834fc5a8f433963744c4538851ee14ffed5dfa24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcef1dd4d5a60f7d1affd61132cc0c73527cc1c8685c6bfb8862433014108e03"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a3a71608c66b8d8bea3559420af13315102ba5b8ed2ecd84307469df963f011"
    sha256 cellar: :any_skip_relocation, ventura:        "6438c99cecd59ea4440689e31c411c2a965cb8a21f465b30c0e0ebfe50a457b4"
    sha256 cellar: :any_skip_relocation, monterey:       "1db5d1392a745f028244ecff7e825284b9e06bb7504bc3c36abca9174f0c348c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f8712106d2700752b2098d7b4f96588eb2ef05a5406fbd6f1451a53d38630d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end

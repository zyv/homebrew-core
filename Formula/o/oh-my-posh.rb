class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v20.2.0.tar.gz"
  sha256 "726cc57dab590f99f033a13a6353d6d47ae7632d61b1ae35c44c32c38f593f05"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc648e1f6f4e493600cf132c7259c4b0f9228672230d47285d105e5acd391f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3331b86898e1c315433b897270d9c53e75d0e10655dc1789895bad5d51ba2008"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da67d56ba81073a02550298bf6c330e13f21dda312b27c6533bf35364a0a6782"
    sha256 cellar: :any_skip_relocation, sonoma:         "2102d7d38fff7ed733d84860b2d03bd554e0f85e177b525505ce6b65dd0818a7"
    sha256 cellar: :any_skip_relocation, ventura:        "49e3aeeaaacacd03b3ccfa9ce383fcfd34d1eb755062447dfaa520b22b91d248"
    sha256 cellar: :any_skip_relocation, monterey:       "fbc19a481ca4e5048529ed3319041b12bcbbfa9b3d670c148dd1509ffbeff1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f004d73aa39598af3a977895b2790d8cdd2777ab2744c1a70a2e309a579a5ee5"
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

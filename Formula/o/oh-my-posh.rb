class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.11.6.tar.gz"
  sha256 "3484a2928a549599ff15bd93598944a269ca2d19f0bdd775085ccd1b85ed9b3a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ebc0e4b2a2f039df8abe5a06b9900198e4cb996924db37ed54d9863aac29f87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b036a1e1044f83e4458ceff7ac381bb862c44a7053bb7d2a2d0268ac06dea714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9344253ee15d2e393dd503096beac92ca81896da4d456f18fc0a76396c604a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7620e15b46e9a9eeaa74527868b766edac6ec52d80a105c66138bae01b8f523"
    sha256 cellar: :any_skip_relocation, ventura:        "a99a2cec2e5915be1483069b3a3eeae933dd249f5531fd7e41c65ee332ac46cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca26f1fe7faa776ffcb4d2167772d2116c592a4c5141aaa6d31320ef19a6933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3177e8be55106d29759de4d9c8d818146a945b23ab241fd62cfa26875219bfb9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end

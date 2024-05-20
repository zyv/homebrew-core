class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v20.0.2.tar.gz"
  sha256 "70bac4e8280be1fb03c930fcd47621ce4bcb6e983f4956507b09572d558b8837"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "664f8a26f6455d0cec7d2323993b719c68c1031fe2eec6c819d7d19cd4a9b227"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdc1957ac6a5e40180250dcd5e558c2ab98af382bb53d8926e60a07d1d54c43e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97f0bb6759e1d056a0ffcbf3308df6dea922913927ddfa8c7eb8bb5e9698293"
    sha256 cellar: :any_skip_relocation, sonoma:         "32fb28ff4a6be6c80a6ba1cf6351e1ec0367d9982415e74410c875f583b8db0a"
    sha256 cellar: :any_skip_relocation, ventura:        "31aed5987999c9c951e9f28ca1567f6d72889c2745e7094667cfbcd6546f99c0"
    sha256 cellar: :any_skip_relocation, monterey:       "6b3b0da504ef635cd7804f3d87f8d39ffc3fa0eb545420fc94b0aa18c46cfa31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1d990bf364383c403845e796008dedf22c36803c3f99492401d6df4c41dfb2"
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

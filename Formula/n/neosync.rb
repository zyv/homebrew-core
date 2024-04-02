class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "0e733b2a42d0e3e6def7339b0ab5f38737474037a878a926614a8312357bb221"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bae12c4a26b1c52ea0afb13f2776a0fd462ee7f253c5503d0192d2c7ed5c344"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "450d714d4bc465f8990b4b1a0e4a9c997b8abe462ecab745def1d77803f98324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c00dddb10fbf700849ef12ad0839c24e69a86dd2056c8b76d0c1f09077198e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bef7292502842428ca69ba69948e25a6db646b17d13ce03f04af4ed3fe6bfcf"
    sha256 cellar: :any_skip_relocation, ventura:        "6211e87a1e40c2ed1616aaa8a88b4eaa74d112e359b2e4f9ea05aaee9ecf17c3"
    sha256 cellar: :any_skip_relocation, monterey:       "2446424920344a17d9f90cdb94d4fcbd2ef8aa437ac18831cefcf73de34e3102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b053b3c8caa9bff968976bde63bad3b28b72419bfae30889bb211dc3bb52f516"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end

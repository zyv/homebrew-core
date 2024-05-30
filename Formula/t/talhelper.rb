class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "5d0a03fd4709fbe0dfd7aef6211b849dcbf8da0a3539962b67ca6b2d9b7382cc"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51f8f53d528452ec368c2fe7799148020e596f99d53262a98e0392a3205b3254"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b476213980482c19510cf34f8cdd707e3c254338dda10e0f107bece283785e4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4db3d1efed81f3c2857b4e74b77d801d34729c40847a225cc5eff7112930c605"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea6a23f0e0ab0bc14352f95688918cf5089efbacc9fbef7e1cac899cdf738109"
    sha256 cellar: :any_skip_relocation, ventura:        "d0e3fa78a62a64d2e04dfb4df0bf530c2e97851bff07e3459ef5cdae663306be"
    sha256 cellar: :any_skip_relocation, monterey:       "9b0f52ff276c2d04fec02c9cc9a483afc1f6d85a32f1043035491a3b00563acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786afcb06ff789b218799a60ab016f2be393e5cfe171462e7cfa5b39fe3cb434"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end

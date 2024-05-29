class Sigi < Formula
  desc "Organizing tool for terminal lovers that hate organizing"
  homepage "https://sigi-cli.org"
  url "https://github.com/sigi-cli/sigi/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "06998236aa3717f6a30d7f691649fa85728a2d5c7118d8ad835273409de3720b"
  license "GPL-2.0-only"
  head "https://github.com/sigi-cli/sigi.git", branch: "core"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ce5392cefa3f7b743fa91bd13525fc602d8bc4289e4b4f49687fb24c73c1c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9732c37a1092aa6dd5f1e7bb15492a6450b7d9d256d1728a7b8255bcec4f8222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18fb2ecebd41c576e0b4e8aeb04121f924334157c01f576b860e2f234e523c53"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b867c702c536bb0243978b4e1a9e08c3e6a9650429b115baaf838bbcd01478b"
    sha256 cellar: :any_skip_relocation, ventura:        "4151fa5bc0db6b3cbd11102c8ce8ba731fecf161cc533652bb3be0539562555e"
    sha256 cellar: :any_skip_relocation, monterey:       "10c2e66baa41005b3a96a1212745bd18e6dbc871c951608281b1d3d8573b9f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d063619f613046b9203e321135443b92300f5f00a2fcf50933448d368efa87c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "sigi.1"
  end

  test do
    system "#{bin}/sigi", "-st", "_brew_test", "push", "Hello World"
    assert_equal "Hello World", shell_output("#{bin}/sigi -qt _brew_test pop").strip
  end
end

class Mantra < Formula
  desc "Tool to hunt down API key leaks in JS files and pages"
  homepage "https://amoloht.github.io"
  url "https://github.com/MrEmpy/mantra/archive/refs/tags/v2.0.tar.gz"
  sha256 "f6eecb667fea6978cc53e8ff0f18f86b6ea6e25a651af24d00c941bdfd0c8ab2"
  license "GPL-3.0-only"
  head "https://github.com/MrEmpy/mantra.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output(bin/"mantra", "https://brew.sh")
    assert_match "\"indexName\":\"brew_all\"", output
  end
end

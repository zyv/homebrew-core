class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "57998b71bb60b2463abf41c26ef5c5272769ba6bf97114a76056a1950b90f7d1"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end

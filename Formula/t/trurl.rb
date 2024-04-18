class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.12.tar.gz"
  sha256 "67a1620ebb0392a9cdd8e46bc44a14e0a5d8c1a9112859fbbb525ec919d2fa9b"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31f50eb8336d2e68c2a95c7cc8baefa0fdc810d58d4071d534a129d98e82e5c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c29fd5155bff88e1acc41e145d52e6ec9838ecfb3337f740e978d4cd6e555453"
    sha256 cellar: :any,                 arm64_monterey: "119765466dc91ac26d31260daf771945179c09840cf1a4a8610f922ed717a772"
    sha256 cellar: :any_skip_relocation, sonoma:         "f076b3e9961a5122f97b9825875c79d7a13e5ede64dc500a0b7f9a37cda52701"
    sha256 cellar: :any_skip_relocation, ventura:        "b5fe9d9b80283e7976765d227f1988b8a1e05b2e51e7bf3389b9b2163c2fa667"
    sha256 cellar: :any,                 monterey:       "97096b60051a0578cd568232c2132b9c72054773409d941482f61cea2200922b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3122417e2eb9d44749988533c215e7876b66e40417c7654b3ed3c65c2578177"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output(bin/"trurl https://example.com/hello.html " \
                              "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 /hello.html", output
  end
end

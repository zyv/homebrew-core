class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.17.tar.gz"
  sha256 "d7b61c6cdb5c0d988d1bd71d0d6d97152c32e1019e5e9ce940fdeb3f06c84829"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "326189b2c7119c046c70ba4a870940ee2f20371c42896f15b03c911106bc2ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde2d4470cf7ddb726f924a5aaf316c474e90067a42550979afc9160afd85784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca849c1ea5954139ec7e47b05f71e1b4498d0cb5aa2f80b121f8f44bf58277e"
    sha256 cellar: :any_skip_relocation, sonoma:         "73f561f40ebce59cff8e965d25b5be7e7b03ac7b1c6084f15d36d5168c566eab"
    sha256 cellar: :any_skip_relocation, ventura:        "3304fe18ec476a8e45f37d9da12b16517bc3e266f4a67d6e09c14693c29e9d82"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee4b442aa321cc074b1d9ebbfeed8085ff257862186bc43f48c3eb86a3d19d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c28419bb2507f9b66b322ca0792ebae946663bdd12330191f8183ca347c6d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test" if OS.linux?

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end

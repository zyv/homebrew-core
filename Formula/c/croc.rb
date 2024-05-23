class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "f7307d479bcf6dae77874aa36ac79773c5cd52b048c6481507e226e747ac5268"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eee803cd4435694f9680c7fcde6309f438b2c108770034e0f8ef5e91f90626a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8c3b851af3acdeaee66efc41bb09519cda05e3da68dec8e7448a4e388d548be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c9320e052545b117231565a7c45635efa0cfba48afe7b1dff9ef5eceb0510e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e07437982a373c5801d47532278e7bf27d7f168746d340508fb7694631da2f9"
    sha256 cellar: :any_skip_relocation, ventura:        "4dfa587346caf62e1a978ecfe2c50dbbc54a8c8959277bd604a690022b1d5bbe"
    sha256 cellar: :any_skip_relocation, monterey:       "354438c7b2683d1402563ad1d225fe4922e3764da9598b5f96f181d17a452260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1003538b37f513023b9185d6a109efcd9015606a3fd0aaad45b4522d3fd494b7"
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

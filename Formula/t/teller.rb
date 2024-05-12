class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://github.com/tellerops/teller"
  url "https://github.com/tellerops/teller/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "d340d160f00c0653d3160cf16aa41d22acb240556464d8803f234f1fe46efcef"
  license "Apache-2.0"
  head "https://github.com/tellerops/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6704477a5bbff6ae77e598d7f3e23a8e6ed29cacd4569d06ad813187f4bff6dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c233bfc50235f79a795811a99adc75e4225abd0a80215a540817d00156fef93a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a3828e6f65e1cbd3424fd5b83e7d83868917c8895bf2aacabbc2483e25a96a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "12bca722b124885d676020473e0928ab3cc6cbd4ffee3d9550b91c0619679c8f"
    sha256 cellar: :any_skip_relocation, ventura:        "eae9f8e809b4422e262d3efc14b46aac3bed6b2d650d5296a6b2b62176aab17c"
    sha256 cellar: :any_skip_relocation, monterey:       "8f5e8a3d924bf746875503648da58fa6c9c68c82e116c1b3e0f5a4e1bbb288f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79cfdf095ca432dacdae22d526d9707ee3750d93d453054dcf9e2f8175346b5b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "teller-cli")
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo=bar
    EOS

    (testpath/".teller.yml").write <<~EOS
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          kind: dotenv
          maps:
          - id: one
            path: #{testpath}/test.env
    EOS

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show 2>&1")
    assert_match "[dotenv (dotenv)]: foo = ba", output

    assert_match version.to_s, shell_output("#{bin}/teller --version")
  end
end

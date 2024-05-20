class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.16.tar.gz"
  sha256 "d535362d0900e841090e48cd1d026bca66f428786adc627a95fe61f1e0ea8c00"
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

  # Version 9.6.16 reports as previous 9.6.15 version, reported:
  # https://github.com/schollz/croc/issues/703
  patch :DATA

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
__END__
diff --git a/src/cli/cli.go b/src/cli/cli.go
index acd2a18..67598f6 100644
--- a/src/cli/cli.go
+++ b/src/cli/cli.go
@@ -36,7 +36,7 @@ func Run() (err error) {
 	app := cli.NewApp()
 	app.Name = "croc"
 	if Version == "" {
-		Version = "v9.6.15"
+		Version = "v9.6.16"
 	}
 	app.Version = Version
 	app.Compiled = time.Now()

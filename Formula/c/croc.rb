class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.16.tar.gz"
  sha256 "d535362d0900e841090e48cd1d026bca66f428786adc627a95fe61f1e0ea8c00"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6e7cd5f01893567ade07728525562bc82169df3726ef6b00dc559f868c1dbad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59370de024a5301e8f66bddb247c9775e03554fe0bd5a629990bd665c97c65f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6fcd5a24500c927a692141be69e8e7c4f0dd584deeb152367114708b3748afc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2466517bcc89f8465b01cd2437d4d0be116cde6459f48599e915fd4ac78cc93"
    sha256 cellar: :any_skip_relocation, ventura:        "44d29b9d33ed7b909730d6523fbbb38924b11e85f4cdf4b881f8c87e5cef7cca"
    sha256 cellar: :any_skip_relocation, monterey:       "b359184b91e95b4a3ad7c4feae77b0de183daeefaf1671b7ca1ff25490ad6b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65b2f6f2b44197a0ba60c528d369773b2457d66edfa6cee33cc7382c885a5b2"
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

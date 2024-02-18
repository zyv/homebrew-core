class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf59878de31b57117cd16856932496870392a427029c303457cc5afc52aa420e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83da7f95101c0852850dd1e45dcb32fb1ff49083cf87b9e8b47e45421b0c683c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b5db14f37acef2fbf72eb9ab63eb60e2fdd5db15b897ebc05f57b71f01f604a"
    sha256 cellar: :any_skip_relocation, sonoma:         "08a01645a624039015a5bf04a2b9435359ca449a0743ce23283367ac46cb1dd2"
    sha256 cellar: :any_skip_relocation, ventura:        "54bcd6f5dd82ed6d41fc399e87743113398452fca1615b23f26e272feef900ca"
    sha256 cellar: :any_skip_relocation, monterey:       "5bd2829ce9195af230097370551638610b4a30734f1e4e05ecf4336440dc59e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c83f94f157da4e0dad7e4e4dfd424ea4ced61fa05928447a3fd5ae88122a0f"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end

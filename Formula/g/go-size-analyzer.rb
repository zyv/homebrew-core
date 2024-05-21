class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "a45a2573f2e8b9cdac1232d758d13303fa214d806bfa2c3ea3a0a634576504cb"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0295f8e805050118c524e9d65d526c22306ce409a3abf4e6dc833fb21a305ce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8b452033f21a576645042523a0d9c89ab78d90e5333e2359563b2492dd7fb09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b105ccb44adea75f06bc9bb4626fdd971c840c2da80c32f3b544e9fca0d3c62f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9767a0f8154be2040312ac780d1b78136c1a2873d66d3ebfe83ca55318955400"
    sha256 cellar: :any_skip_relocation, ventura:        "9676b74daabfb5291143a8738ae95ab5f47ed6db120c70a5da23fae0749caa77"
    sha256 cellar: :any_skip_relocation, monterey:       "951928802b9c5feaf950048cf5b4c3cad87ebe60f05ae81447c7271f13dbbe8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21ddadcb255c1ef0b898eaff1b913d6165c9490786ba0ead6a3ef6f5e640648"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build"

    mv "ui/dist/index.html", "internal/webui/index.html"

    ldflags = %W[
      -s -w
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{Time.now.iso8601}
      -X github.com/Zxilly/go-size-analyzer.dirtyBuild=false
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gsa"), "-tags", "embed", "./cmd/gsa"
  end

  test do
    assert_includes shell_output("#{bin}/gsa --version"), version

    assert_includes shell_output("#{bin}/gsa invalid", 1), "Usage"

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", "-o", testpath/"hello", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end

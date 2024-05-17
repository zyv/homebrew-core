class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "5fa7bea825991444aba84237686d7ed8c4682ab9078ece19a2037af9906d7719"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2027f8d863cfa91c0ce53b5403ac0a45791e28dca5e5f9c9d91bfcbbcc378aa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d055745780565590ca5bf67de397117a21f173ecb10c534565fbceee9b630a7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05ad663b77bc5af08259a28c1ce6fdd4a0e52f42bbc09225e0c64a9aa3cf67f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5ca300004519771debe8d1b7a7e60081cdf03358446a1a2d1dec30387a4b349"
    sha256 cellar: :any_skip_relocation, ventura:        "43e3057467f687961faa67f8e088906aa4a75eb7d422c9a37cb8135f5f4156a7"
    sha256 cellar: :any_skip_relocation, monterey:       "8e9378d08f71673c107f11130664e3129e3a56c0f257d26b6acbc563ed165d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dcd202e95cdf28705c73594e8e69e6cc049536b2d662800dfd3d73535e623f2"
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

    output = shell_output("#{bin}/gsa #{testpath}/hello")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end

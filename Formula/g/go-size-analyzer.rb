class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "a7261e3b6067e3d7e35d3fc0df93f220d8ed9a8a1ef4d1d775690df225394162"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4bf0a150ca3c62e042a92ad636a9197849ce0d856eb349bbed3ad464461d635"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e59e73f88af994f4548c87b12e5e82563ac63bc2eaf5975bbad2f0f3f16b119b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f445e30e0e20622dba086351f4f6bbfa968d643d711d98bb1bb575d80413c673"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1f820ab251579bb6d60bca8be8819da6232ec5dac6ae12d30a9910eea5fe613"
    sha256 cellar: :any_skip_relocation, ventura:        "bc933a729ad18f5525f0c5ff7a7e62eb6750f72e61a8f05410f62efa737fb75e"
    sha256 cellar: :any_skip_relocation, monterey:       "edc29d94712d0fd40c5036a26586a93fdf17aa369a8d2efc4b8f2508bafdbc2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0febf5d2b354e920a5b200d523ca35adfb2353ed6b3dc8fd276f6760039bf513"
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

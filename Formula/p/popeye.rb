class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "9f456ebc8fdb3c9fee8ecdd102832f1217da26a41548376d16925e9fbc1abf9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21e5819807549e065772460deff1b415a37e67800bf7e1f84f982df2f9ef3d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9692f8ae0a3fb7211c36a0fb1c3016e98f61517094f46c86ef32f2897bca9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0524a0f1914b791aa6fa9daaf013d3f8690aa9f71cef4f1932c8b8eba8825769"
    sha256 cellar: :any_skip_relocation, sonoma:         "38e50fdae71506c00fd57faac369a9160c599dc632e24ec75cb170909da7a482"
    sha256 cellar: :any_skip_relocation, ventura:        "65b88d440f7caf7e3f3f41f5adf3cc9221538d605e3a9e555c1ebe48c20a3cee"
    sha256 cellar: :any_skip_relocation, monterey:       "1564378b74b4bfd7d3bd08c080358d93593fa6736a1398a443a15c2b58cb31e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d70d8dc16e94e2fe5504c10b5a4d767fb4f566352297688acd033ab97ac58d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end

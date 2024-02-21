class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "4216984867e6c2c0a5576d75f82cb3c7c51766ac7d1dbc01dffd71abddcbdaf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe2d274af946327eb7957d83f4cc40871264abf133d7fd58d0c1628c5a9fe90a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4292cc222b1316d427c65b14cfc258b2dde69237a07ba1c002c3adad338c8460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e6964a0fc3f21e26d60d48556c708cabb8d2a804d7c43e65ce79bb17dce7c4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7353dc43c8d24fde43a798d39eb55f80f28b21ff0a6eb993d54f9407242ee9c"
    sha256 cellar: :any_skip_relocation, ventura:        "1dcc409c7c06fc80d884a503b4f224e22eccf61f2ee48966f5cce2ee1cb8a2ed"
    sha256 cellar: :any_skip_relocation, monterey:       "447a5bfc60eea710ede0b36d9c60d4d0feb379fef68a0d8706c0f8d24f01d21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2113343d8cf7a05e60dfb91f4d55b45eebdceb74c876c82b9970448630684d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 2)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end

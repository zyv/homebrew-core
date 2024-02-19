class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "c84f89723bdc3d1aff20c9b6660b6af6d4a74ac90ea6aad6d50933f18121a192"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a327692a0b1cb3baa1783fd308d1072c16ee60640e5c7c2b716e32734ccf2eb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "058d57c5a8b48724b51d92413840abdafa14d287c7655ce4c4b785851721b56d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca25aeca8fb171edf09e436a548bc8a13c737e0edec67baf04dfdfc4bdd6e6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "61d6c2a13baba3a58c9f9d77b02237a9219c242989d64aab6d23d03da6f5f3f8"
    sha256 cellar: :any_skip_relocation, ventura:        "dcc43c08b279b1ffa077713b49c523f55661ec98552bdc506bc128339fd56c90"
    sha256 cellar: :any_skip_relocation, monterey:       "a23db2b9d87d741c3254b44f5bb7128b9fb7d96118c136e5e86916b2ee0bdfc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3e73080d7f5ecaa1acdd56788c3abc651a7610bc36f75082bd7775a1eaa2ac"
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

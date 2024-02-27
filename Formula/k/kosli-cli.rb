class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "cdd5f298f4bb88b2c5c96cecc21858bd609c99d5be96ed13c1751dc8ae445bf5"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcb4c893815a08fef017a41c64e2998d49339c324773fff33cbff4faffc57fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdc340427459b4dd4b5f41cf7dd68e28f9f7620e124200c9b64ed81a657e5476"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb62df9ea6321cc5fc4d08f79a71f94706fbac9c47a430e27f22d453161984b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e15027d32e5504a94e64e4a0bb36a997382a3cfaca62ddc5fe3568693f25ac49"
    sha256 cellar: :any_skip_relocation, ventura:        "b7593dfeb65827aaebcd1b067c87549be657ec49f529d3d6909fab6b10e3fa59"
    sha256 cellar: :any_skip_relocation, monterey:       "d921d86a808a0386261ab0178e5468bd8e78db50c5fbf1b042c593c34eb7d360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c6e61660fc54044c48b546a564fe93e846551369cbb8ddc6d1fb1613e02235"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end

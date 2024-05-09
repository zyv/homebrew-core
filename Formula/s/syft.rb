class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9d16451bb69512f7e3732ee6b5170d0a57efdf8d5f80545383e4fdc159e71eca"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9880021b909b216128f4b94a1d58f7f494775fa46638011f90c77d7b4af40fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "533d066054f4505db3076133f49983664073e605e4be98cc5b5efec95e509c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec50c546546b881d4a0d6e90f154666761533a5d17fb0db15bf290d42d2bfdbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ed66e0efc0dfc1dd38ef11a3a48b0da048a4dd89dcdad98f32122c6cfc8fedf"
    sha256 cellar: :any_skip_relocation, ventura:        "5e4dd6471f99b3b1ceb2816ae5fab1a5bb20ea53b03e9bf7aeecea18e8c04c4b"
    sha256 cellar: :any_skip_relocation, monterey:       "f8f4eaaa175a2e25edfdb406d51c3ff96b20791aff7c0c7aab1424a888f5dbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14dbaf9337262f9b2e02aea18ce145f323586a61b50b2ff88442d4d8159ee4bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

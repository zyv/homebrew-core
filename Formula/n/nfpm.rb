class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "b1e38fc92a62a8d763f5c1c305882df6bdbae34979558c866ee9e19379c1fc0c"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dcfa47fda850d30f879e5941ce4e42958aefdeb52d98f683fc8334e8b9d7601"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bc8f0071b3115e222791eae4ac87af7bd1d0ab771dc7c7c938fead750d44fa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75674102a8094e90bac825dfa1426c643dda707bc2c681d9b0c5c10e53c04079"
    sha256 cellar: :any_skip_relocation, sonoma:         "87c9e2cdfc7329a2c0f7e71fa268b7effa1aac86eecece36fb600587664c2718"
    sha256 cellar: :any_skip_relocation, ventura:        "7ed847685c42ed9f89706d11d7651fc3dab51f07f77aeb44b9237109188fd7bc"
    sha256 cellar: :any_skip_relocation, monterey:       "2c1405bd4c7786ec5523c3ba8abf3d37271ee5f30ab7dd58aac991c23d6ada97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "184272ad5ab0825075c576a1571485f1f3e88e9bd3a29c57796421be3d4b1865"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end

class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "1ce7d68439c2b19550417890c04911fb10f1a7dddeb82947f485ebf198c86dc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c9b10d920437c0a4772ad1e6757d410084096c58d2485ed0508ad7a0fa340d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63589a190858ed45d583e5371d1dc34ccb84259095b90287ff4e42a58db78912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd678479418aef53b95cb14a5ff69d3f1857d7dfc56debd27db9a9d0f58b24f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "60a72d74fed285740f267c54461eb46e53eb7a8e52fe58630e073e41978043a8"
    sha256 cellar: :any_skip_relocation, ventura:        "6be90f43192964a9c5c5492142a02d2cd5e598c06e20e179cdfba1c3dd849f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e32c06ab5b7094c186c18e8f41eed745ecd71f035072ba4a36610ab2977bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0efd2606cd42e919f267661d613834253edc9e65b4f15a99901146e76957550b"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end

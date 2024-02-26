class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "f2b61511a5b102c6f8db23189dad6f771d7abb2894882c133b8f78031f9a2c21"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f244998baaab952c9b5f4e5dc82937b3d30b27da81fed196fde4ef86c777b632"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b46b1cb1e495010d4af36f3fe0c1a6b8c6c5e29288905a1cd8d58580619ac56b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10aa9c4d85596007a02e72e940f555160e8c02e7ea540ae34e13cc53b2c5f9df"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dfd478806e9a29d9917b21891bf88fe14f0fd70bac3f889310bc074a66d35fb"
    sha256 cellar: :any_skip_relocation, ventura:        "7c64a008cddf069cc17c3df2e501a1cd47f95fa5b2c0fe6ecc1231864965a5cc"
    sha256 cellar: :any_skip_relocation, monterey:       "83912705c5ac3b5d6f5710d2413fd9411a7041dcccc96b674f7c9c1383f9f831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d81504db6834f7cef3c8ccc23c540c6f224da76711b227671b93ce619c0dc8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end

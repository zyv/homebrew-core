class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.123.6",
      revision: "92684f9a26838a46d1a81e3c250fef5207bcb735"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b75c23a98fab2ad1d26b1217ae327a0d694dd8e3fdfc3129a604a3f9fd555ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb1fbebcb069c4edda808350944629dca3060d9140f3bfbc84201d1b7210a4a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58127a88d7c644153ef9903052987c9107bc09ccfde433e9fc9cc8cfe45c04e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f45ffd51625a7217c9a472bd5e237995c1d5c253c7aacea28e7427354a544755"
    sha256 cellar: :any_skip_relocation, ventura:        "86669f3aacbe989c0166789cefef4585bec278f1a4f25c9be86858866b711961"
    sha256 cellar: :any_skip_relocation, monterey:       "e7345d4a04a6c085017cc847c0ca2c9a016dcaea519a18e808d3bc639062c1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa673bbe17d413e69319e783c6cf82ba104edeec9a41623db9492a74847f522"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end

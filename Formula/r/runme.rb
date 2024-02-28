class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "905c9090437398557c8326f67c875f8a415fdcc6b6d2e73582655f12bc4cfa2f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8107a0d04ec653d4b0bdec97b28dacb931e5aba07ec19e97c7b8fc74d626b3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fef59dfa98a4fc4ca88536109bcf86485bf4811d7c7ba973648180f387273379"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f3ecd13289d6afcdb7e8682b67614641ec0f973713254a929911b8b4cff30a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d40e066b9a5a4882dfc92e721aa04f48a80b4f5671b91eae2b952ddae803142"
    sha256 cellar: :any_skip_relocation, ventura:        "7d7bd6f367005f738d9082ab901fa547c51590c77c5f8bdd0dcd57adcb9ea0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a992aad2e78da817e999b5b81b9defd5c20fb34c4bb1e286f7a2fb092abb60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037474354f061cb0a010948950bff7e062aceca835124ace10d3f1eec43bf44f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end

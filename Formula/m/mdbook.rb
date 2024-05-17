class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.40.tar.gz"
  sha256 "550da7ff02ef62c60db6e813b6dbae65b9ed3d491186ea74929536feaceea94b"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f7a05c5d0e4aa26e3aea4f78135831dcd49750a7e15580624ee01d5bdc35c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69a6e4d470500b76013a722beb16ec48884fc5933242d88d9610e667e8a4399b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbb9f5703a958f16b778f3a22c01a6904f67cffe6582bd21b647e939610064ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "53208fee38c9125667e9a856b6438ab0fbab094accc2d7c52e0c973a7025d8b5"
    sha256 cellar: :any_skip_relocation, ventura:        "414aec5b7905cf179925b8a05c643d1b1b5b07f228a73a0b52e12ec569e29da7"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e41f60b0a7a45718e20ce1987e42d71aa22fe72857ae0c81dc753e0ffeda82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4f7817cda181e94551c5eb65e463ea6f70218de1f3a2790cc5cf155d858350"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end

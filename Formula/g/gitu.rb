class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "cff28407c95c2e749a37cf9a83e8c0c3265f6e49d3a2322fec862bea794d9347"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65253bfb5da1073df72e62df30f34fd3b07e6838ea52d3de045c18452cbd92ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd6961efcb521e8789921bae7dc8483c31498961a49adb2ce34555c614bca9df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70554ba41d63903d1c611f5c14f63595b1dabc7fb50d7936df28371fca9282b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e7e63f7d4109e51fb7e2f557b537aa5f8f79278545ad7176166e3fc3571c62c"
    sha256 cellar: :any_skip_relocation, ventura:        "70db96fa8bbf8795824725f39eed12dfc7b5152e434d878c6743a259a651040f"
    sha256 cellar: :any_skip_relocation, monterey:       "66612931bb30b74d8cf81f851b95c9e17269303588c2c44013f9665b2a06b192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4903e9f65c3ad653d2f02b078ab14ffce04cb0ea848424f70c96935eedaf3fd"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end

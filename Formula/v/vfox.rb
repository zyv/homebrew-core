class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1d4e4e01ee1ec747fe47983ebdc5a9c60e12eb772b066f84b920ec2a98e1fda3"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b015f0ed2b83bef8dd524f75c1d8a925df3ecd08f6073143f139947b028dabf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5d67ec3c9203cf468a43c70081bc9fd773e175864775c497902a7442fb270ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ae446b7ebbda9cb095a6f9da61137ef57a00dc6b68813ecfc2f3224c98d581e"
    sha256 cellar: :any_skip_relocation, sonoma:         "606c170165b24f4546be0879ba1d35920264a50704148e8369e7f74f81b14a06"
    sha256 cellar: :any_skip_relocation, ventura:        "061959baece57a4199fe0d4342893c52faf74174d2bf4f211e47b3a69f7e7538"
    sha256 cellar: :any_skip_relocation, monterey:       "1d35a3e60c4f4954387f1f3c43cf8a06983ce5558240d2e8b53759faa805bea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f852e7e603534cee18b72b0ef6807c88726ebce26be26a2437aae758ca2c87c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end

class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.57.5.tar.gz"
  sha256 "e9c83c5cd0dc0411f5dbc2f12f6846e954c4a2728146cd321de7f79b75546b04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77a920b1683135ddae97b617534e27bdc5699df04efc023304a036a30a778354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d2a53dc86383bc4f785b6c32242223cb3886c29f70a3d15c8506952f7442db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faba9092532ca68b8f8c178ae7b7e68f496c4bee7e1bff5e4870fb05aa6873f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bf02eeb906844409914b2dd32a62b07e8883bcb616f2c3ed2366c8150780e6d"
    sha256 cellar: :any_skip_relocation, ventura:        "009352298dacc7f9a43c6b9f2a91175ffe8e0d46b45b3c95f0c7c6800f3b1779"
    sha256 cellar: :any_skip_relocation, monterey:       "eee5edffcbab5607bd5fde6b84c67f42cd6c3ba89230a7ff1ebab4999754fa85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab903d122307caf3563ff8720ec2a1019c3d1a2bf4edb80198df48a86bca54c8"
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

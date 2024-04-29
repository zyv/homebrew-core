class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "ca315ae50e00c6a02e3b36f29115d4eeb71bc8f73126da3de7b73b2b21f2effa"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tenv"

    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end

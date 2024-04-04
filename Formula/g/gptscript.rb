class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2a6ec0fec133c6e31cba3d657771484b585792a4b79a3f09dc7c4bfc94b4d25c"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b22b64493d15328d312ffa64eb7c430cebb39dde9cf21f7e0a45184791391d73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e39500104128a3a4646885e78d24ef116dc5f026195c997a7d84173ac6cf453"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf67f804d979835811d2af652faf19263bfd8895e2011e5df01715fae1df83c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "91f184b1705114f7e5d5552931d76557a536810d089fd32f32fe615113cfe03f"
    sha256 cellar: :any_skip_relocation, ventura:        "f234dc80f8fdbf5c937c4a0e6f13682a1da430cdbe6fdcc914f61434bde145d5"
    sha256 cellar: :any_skip_relocation, monterey:       "cb98d7d410fcb24282324f96d36baa1b36ba5eb9b8c8a1f7df46ea22618087de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68147ae9621293c7dc246e9b07582d9b1a980694afd33b97962d6d6bf9131474"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin/"gptscript -v")

    output = shell_output(bin/"gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end

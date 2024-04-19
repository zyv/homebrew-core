require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.59.1.tgz"
  sha256 "254b3ecf34c16c4ea77b3a28fcc2e1620ecd8a4df2fbe41de4b00455b90114ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3494ff701d4e4972ae21fa28c20db4819aaacccab3d5a90cdcb22fd7fb1270da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3494ff701d4e4972ae21fa28c20db4819aaacccab3d5a90cdcb22fd7fb1270da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3494ff701d4e4972ae21fa28c20db4819aaacccab3d5a90cdcb22fd7fb1270da"
    sha256 cellar: :any_skip_relocation, sonoma:         "846e9d888608bef76bebf868084c2a772fe9d1ab6407a1765f850c350566e791"
    sha256 cellar: :any_skip_relocation, ventura:        "846e9d888608bef76bebf868084c2a772fe9d1ab6407a1765f850c350566e791"
    sha256 cellar: :any_skip_relocation, monterey:       "846e9d888608bef76bebf868084c2a772fe9d1ab6407a1765f850c350566e791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3494ff701d4e4972ae21fa28c20db4819aaacccab3d5a90cdcb22fd7fb1270da"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end

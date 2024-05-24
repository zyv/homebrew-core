class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/d4/4a/fc3f5a08a8cf2354472402f49cc7b9c7a3f27ce6213cb3462abffaaea423/git_machete-3.26.0.tar.gz"
  sha256 "7623d0c5ed10bff16471bca2d5879d63f0a3d347b348a60a6570ddcb60337cb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7f84c41bc121d894eb618fed9f4f8c7b9f22b1bc8f5ef1a6a133bad855b4750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35462aa732b61c6bb6264befed31107da5e7a0ca1132420df85ec1a164d94c39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c52e4014059fd9555bbdab43ad06fa6d0bd1427dd412a173fe26489034cb1f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f00b3bd0021d98dbf61184f27f556a9b3de10518458f525e2971d4a80f22cee"
    sha256 cellar: :any_skip_relocation, ventura:        "ef8de9a27d6c0398ebd7ae0e85ebe5446b1e91256955d2310cfdc78ecf315f3f"
    sha256 cellar: :any_skip_relocation, monterey:       "0d3f15b92ae8df8ee2fe03288a2eee456c92121fb8d9be56c99d629e71fb16ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5044e0989aa94e7a321a86e54673d76facf571100e10184f9989b1a8285fee"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end

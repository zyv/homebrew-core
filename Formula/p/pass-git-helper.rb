class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "04a48285af405e1358139bb83193484b198e7b19f782f1b97165b62d2c964bfd"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31f6f2793fddfc326d7e8b613b3b7fd5304ae09e65ac3cd388328874d93100b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f6f2793fddfc326d7e8b613b3b7fd5304ae09e65ac3cd388328874d93100b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31f6f2793fddfc326d7e8b613b3b7fd5304ae09e65ac3cd388328874d93100b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c8ef93e8d4035d43c0f60fd5f2c017545a2ad3aeaeeff4a3209276f4d8449e"
    sha256 cellar: :any_skip_relocation, ventura:        "08c8ef93e8d4035d43c0f60fd5f2c017545a2ad3aeaeeff4a3209276f4d8449e"
    sha256 cellar: :any_skip_relocation, monterey:       "08c8ef93e8d4035d43c0f60fd5f2c017545a2ad3aeaeeff4a3209276f4d8449e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa3b90d39c93bb7701bebdef7faf423c8268cf86b24f67d3be2bca9d4bb5cd8"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.12"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generate temporary GPG key for use with pass
    pipe_output("#{Formula["gnupg"].opt_bin}/gpg --generate-key --batch", <<~EOS, 0)
      %no-protection
      %transient-key
      Key-Type: RSA
      Name-Real: Homebrew Test
    EOS

    system "pass", "init", "Homebrew Test"

    pipe_output("pass insert -m -f homebrew/pass-git-helper-test", <<~EOS, 0)
      test_password
      test_username
    EOS

    (testpath/"config.ini").write <<~EOS
      [github.com*]
      target=homebrew/pass-git-helper-test
    EOS

    result = pipe_output("#{bin}/pass-git-helper -m #{testpath}/config.ini get", <<~EOS, 0)
      protocol=https
      host=github.com
      path=homebrew/homebrew-core
    EOS

    assert_match "password=test_password\nusername=test_username", result
  end
end

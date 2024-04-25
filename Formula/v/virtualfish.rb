class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ff/99/3d94808b610a4992595e926340e123251ec7c772d4ff1cc9593480f346f9/virtualfish-2.5.7.tar.gz"
  sha256 "f507d8cd281cb1c1ebf6021fc18ac20a85d8afbfc5ea4fe8eb0a3f54349bc9ba"
  license "MIT"
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65deff56f7bfda016430a19ce252cc2e7318cd31563ff5140bb90f0b64badb0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "982e1d4a943fd468ecdcb2196a29d6ed6f42fd8a6d21eeeb739c45464b85c067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9da9c4a06a1f1ad1b00530fd6e861f5bc5a328bfeb2560d5d9eb029a320616c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3215b85676fdb3b91f4aa75d2b9a5d975902d501bd6979f3bd926da66d028976"
    sha256 cellar: :any_skip_relocation, ventura:        "aafd7742e3085a0785fa5dd966442ddddb1ba4052d23f806927256e9293e3627"
    sha256 cellar: :any_skip_relocation, monterey:       "b05c553e36daeea3732b8529ccfd772eb5dfc9ce35144cb98e31ca3fc9291d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70961a036370488acbebb91ae0729bbc23836c4a2cd197158f48d394fd6071e9"
  end

  depends_on "fish"
  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/ff/877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62/filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d8/02/0737e7aca2f7df4a7e4bfcd4de73aaad3ae6465da0940b77d222b753b474/virtualenv-20.26.0.tar.gz"
    sha256 "ec25a9671a5102c8d2657f62792a27b48f016664c6873f6beed3800008577210"
  end

  # Drop setuptools dep: https://github.com/justinmayer/virtualfish/pull/244
  patch do
    url "https://github.com/justinmayer/virtualfish/commit/b7ec2d4f37e30adc327db115417d93e7d223a2ad.patch?full_index=1"
    sha256 "df2f769a066eb75c08815e9d30b8fa33e00381794e6e40731df909212d7fec7c"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To activate virtualfish, run the following in a fish shell:
        vf install
    EOS
  end

  test do
    # Pre-create .virtualenvs to avoid interactive prompt
    (testpath/".virtualenvs").mkpath

    # Run `vf install` in the test environment, adds vf as function
    refute_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"
    assert_match "VirtualFish is now installed!", shell_output("fish -c '#{bin}/vf install'")
    assert_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"

    # Add virtualenv to prompt so virtualfish doesn't link to prompt doc
    (testpath/".config/fish/functions/fish_prompt.fish").write(<<~EOS)
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    EOS

    # Create a virtualenv 'new_virtualenv'
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
    system "fish", "-c", "vf new new_virtualenv"
    assert_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"

    # The virtualenv is listed
    assert_match "new_virtualenv", shell_output('fish -c "vf ls"')

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
  end
end

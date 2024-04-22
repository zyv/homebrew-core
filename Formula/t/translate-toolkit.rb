class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/54/f1/9019d19f844d0206ed671dcbfd6a8c9020af25bb021fcc861ce66d3d4e0a/translate_toolkit-3.13.0.tar.gz"
  sha256 "d31a1191894d0ad4ed99697663f1462e9a1820af3bbcf6848235add20cc00e62"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb131cecf4589b91ac1fcdc6be14f5d66bd90fb56ac971b6724fba791ff947d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05b1f19a6bd262565931827f65c0d30aa80682a6653c8768762373998cd922bb"
    sha256 cellar: :any,                 arm64_monterey: "b6e991acef5fe55b71ef072876ab7d0d96f334bf5b27e74c5d7634032e56eb25"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd17a8277f141f00e2e25910df358e587a02a768bca73c14ab0c5078f5ba8f21"
    sha256 cellar: :any_skip_relocation, ventura:        "70cc093935fd4fef86bc980d6e3f8b266e2ce5948bf6e9f550a198488ba08ea7"
    sha256 cellar: :any,                 monterey:       "0c7a959ec9e2a726f7a1863b1847c7ce6ad21c3af9aef90011924484cad8518d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44e7606aeb5b431ebca6bd4105bbea00811418a57729f0b619b4f66d206130f"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end

class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/58/66/bc509b61df9a317689f6a87679f2f9f625f6f02dfb9d0e220bd41f121f07/proselint-0.14.0.tar.gz"
  sha256 "624964272bea14767e5df2561d87dd30767938c8cb52fb23585bc37580680e86"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ed17aae83ab4db2184a89ed428f0f55e7460e81f549e74b3325d966f7dc4df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e6e0f868c31a9a934209e57c5a3980450af0c8fe44f6bb61edfdfb6b71d6c6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be71ca3ef347306463ab8aa9bd64e1a53a5511776268683853cc0175e5f9d676"
    sha256 cellar: :any_skip_relocation, sonoma:         "61131b05955cc82a2f168ef03f21cda3e5f312313a11841b78c92a825e3356b0"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea888644c7b7e7f21104ab2360d004db60011764c048a52a3848f9986787a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "75436637988d1f5e7dd286c2cddb563b4b13e82c210276c3f04e006f8f7ff844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207764a7a35aef6ffda10dcbba76e5cd3b54e2662ec6e8e5ff091fdee6679e35"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end

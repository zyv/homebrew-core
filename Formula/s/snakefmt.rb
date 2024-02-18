class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/1f/ce/d2dee5da2cf76cdec5a5fb9dc7b99849b08ea28a5dc17830afc2baadaffc/snakefmt-0.10.0.tar.gz"
  sha256 "53eae69fc81425e2192684eba76171bd648b05dcba93c9d5f45746d3fadb8617"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c380f23bcefe6ae493c5e80fa63d11d4f8c91eabdc8f7193c2a5f9048956355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb73ba8b36c759effa2e4b2ef7c4fb6aab7c36cfc813cd342ed7397ace3c8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd85b4174fcaae8451eec7a2b8a53df6d42fe086c389bc87f3c0ec652e1aaa42"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0a3a5feccf5a0fb29ff4335cc31372961f4e8401baad5c0f45fd8d3adbadd81"
    sha256 cellar: :any_skip_relocation, ventura:        "de5275204de7ef868613ff572e8963227a8c75997a801fd297b5a6ceacca14c2"
    sha256 cellar: :any_skip_relocation, monterey:       "f373cd795202fea97e9218333948d2b2ccf74bac3ef267afe0d20c4bde801b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bddcb117afcf59fe1d937b5e63ad31af703779787a1c03f5514f277b7bcef36"
  end

  depends_on "python@3.12"

  resource "black" do
    url "https://files.pythonhosted.org/packages/29/69/f3ab49cdb938b3eecb048fa64f86bdadb1fac26e92c435d287181d543b0a/black-24.2.0.tar.gz"
    sha256 "bce4f25c27c3435e4dace4815bcb2008b87e167e3bf4ee47ccdc5ce906eb4894"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end

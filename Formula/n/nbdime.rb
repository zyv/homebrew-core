class Nbdime < Formula
  include Language::Python::Virtualenv

  desc "Jupyter Notebook Diff and Merge tools"
  homepage "https://nbdime.readthedocs.io"
  url "https://files.pythonhosted.org/packages/97/3f/8f926f0eba7b31a3c67a224e747b0e084c643180c7a7500f879f8bf7a09e/nbdime-4.0.1.tar.gz"
  sha256 "f1a760c0b00c1ba9b4945c16ce92577f393fb51d184f351b7685ba6e8502098e"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21d0016055d4547348270893caa9c0b4a841a89cf72544e42345ff6aff673b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff885cc7219a54cc91a533df4d4d4d3c7b7f76a70db20cebd39ac3d4a77c116c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e260b2011fbab2c8c9d2a715183d1966621ab538817ad0904b9e1d5afd150eb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fffdfb50b2d789ebf3bfe65e35025b8f23ee56788cb3f379e01cb012c53f0f6"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9000f95abdf0efe8b96f5b9ad709b81592d7d43e0c2bda590dffda6bb72600"
    sha256 cellar: :any_skip_relocation, monterey:       "0152188c65f5d27300e5a615c958cc2109a366940a5347217674ce3abdd3f815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f542718a523e9c19e51508e4eebca9bae913e29e069d8068af1cc8f43703342"
  end

  depends_on "jupyterlab" # only to provide jupyter-server and nbconvert
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8f/12/71a40ffce4aae431c69c45a191e5f03aca2304639264faf5666c2767acc4/GitPython-3.1.42.tar.gz"
    sha256 "2d99869e0fef71a73cbd242528105af1d6c1b108c60dfabd994bf292f76c3ceb"
  end

  resource "jupyter-server-mathjax" do
    url "https://files.pythonhosted.org/packages/9c/40/9a1b8c2a2e44e8e2392174cd8e52e0c976335f004301f61b66addea3243e/jupyter_server_mathjax-0.2.6.tar.gz"
    sha256 "bb1e6b6dc0686c1fe386a22b5886163db548893a99c2810c36399e9c4ca23943"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def python3
    "python3.12"
  end

  def install
    # We already have jupyterlab, but don't use --no-build-isolation since
    # hatchling adds additional build deps
    inreplace "pyproject.toml",
      'requires = ["hatchling>=1.5.0", "jupyterlab>=4.0.0,<5"]',
      'requires = ["hatchling>=1.5.0"]'

    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    paths = %w[jupyterlab].map do |p|
      "import site; site.addsitedir('#{Formula[p].opt_libexec/site_packages}')"
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    (testpath/"old.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": null,
         "metadata": {},
         "outputs": [],
         "source": [
          "print(\\"Hello World!\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    (testpath/"new.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": 1,
         "metadata": {},
         "outputs": [
          {
           "name": "stdout",
           "output_type": "stream",
           "text": [
            "Hello World!\\n"
           ]
          }
         ],
         "source": [
          "print(\\"Hello World!\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    # sadly no special exit code if files are the same
    diff_output = shell_output("#{bin}/nbdiff --no-color old.ipynb new.ipynb")
    assert_match "nbdiff old.ipynb new.ipynb", diff_output
    assert_match(/--- old.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
    assert_match(/\+\+\+ new.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
  end
end

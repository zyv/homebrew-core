class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/c3/b6/297734bb9f20ddf5e831cf4a83f422ddef5a29a33463999f0959d9cdc2df/mypy-1.10.0.tar.gz"
  sha256 "3d087fcbec056c4ee34974da493a826ce316947485cef3901f511848e687c131"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1be58251888cd3febd565416be5e22504defa9de1ef64843f7f64e662df199cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e02ade4c58efbee1b5aa5aea88a5057591097bc2f94e28dc8c1af2510e01cc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b678ece22b353db48764126f048e20f2f0dd3e2b830179ff6d8333d3ad65924b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed126de7e65f85460894ed3b5fdeb28cb7a40b0b7484ddf1c2e1cf1e3031e787"
    sha256 cellar: :any_skip_relocation, ventura:        "461700209f73048aa3adcb08dfbdb8d2fa4950885d5975e45b6583a51ff9e7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "166e2fe8da0abecccb95bd8a37a0ec879e50fa4cc79be35ec43e95bbe9243a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f32a3322277ef33aec9170de0dde330f99a963924a36785bde368673c00981a"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end

class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/c6/8e/63d1bb26319d0fbb44b21fc068a7c0dab96e8516fbb2dd5f572f7ad178d2/pipx-1.4.3.tar.gz"
  sha256 "d214512bccc601b575de096ee84fde8797323717a20752c48f7a55cc1bf062fe"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "641eac15d9fcb26cd6db761aa147c018296d9c19738b44b8fac0616e8150c2dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55efb7fe96ce4541390f0b39ac77598ad0ff105bf15c35b90c34d0f28e82b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe4686b8dd3acd4979180dfce1e6d1f80fb6de5d6bda0020ffc9c8749156f99"
    sha256 cellar: :any_skip_relocation, sonoma:         "c22b9432447390a60dc231194fb119a6d9ca65387655c835e3a8a2aab34f26f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c61cca5d6d34fed5c5cff8a537aace76c964eaca1bfaa1eab3959ae6ac3cb53"
    sha256 cellar: :any_skip_relocation, monterey:       "4a2b72f8da1aad0ef69f5b4ec9ee08a52dc8fb8d408745a81b58299d1b5faa3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7a3b6c37aad7a960f25a36c384f8d84a3ad1f88259110112d04e342a9047e1"
  end

  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end

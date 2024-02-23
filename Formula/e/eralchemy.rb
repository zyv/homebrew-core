class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a6ed7900c4ae0d86c0367a73d0ff6347b0d4926c1b5e7ff55585392749564758"
    sha256 cellar: :any,                 arm64_ventura:  "07ddc38eec10f049dfc18f65a158110bba687de240a6019a98a79a1cd19bb346"
    sha256 cellar: :any,                 arm64_monterey: "e45387cbdc1de739e84583380009217fe11afdd30afb49bac433760bb8e1b0d6"
    sha256 cellar: :any,                 sonoma:         "acb34ace16cfeaeee0dbb47d5dcb7048aacced1f1d4c6904eab4b4d8c0cc9bf3"
    sha256 cellar: :any,                 ventura:        "12ab1b4d747e635bb747b087e989b29c967eee5eab308af169d05a20d5616122"
    sha256 cellar: :any,                 monterey:       "d7a3ef294cc855950faf77b476f3ff424559fbcbffae08dc32e6af938a81cd57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5593d71ebe46e3ddeef556375e808b01f9cba7726c61fb7ea7d00e7a825bd725"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/f0/2a/3a7e5f6ba25c0a8998ded9234127c88c5c867bd03cfc3a7b18ef00876599/pygraphviz-1.12.tar.gz"
    sha256 "8b0b9207954012f3b670e53b8f8f448a28d12bdbbcf69249313bd8dbe680152f"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/b9/fc/327f0072d1f5231d61c715ad52cb7819ec60f0ac80dc1e507bc338919caa/SQLAlchemy-2.0.27.tar.gz"
    sha256 "86a6ed69a71fe6b88bf9331594fa390a2adda4a49b5c06f98e47bf0d392534f8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "er_example" do
      url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
      sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
    end

    system "#{bin}/eralchemy", "-v"
    resource("er_example").stage do
      system "#{bin}/eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_predicate Pathname.pwd/"test_eralchemy.pdf", :exist?
    end
  end
end

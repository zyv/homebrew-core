class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/15/0f/826df6c12110de8bfa9357be60be38bf93230103a9f39fdfa46708ef9200/Glances-3.4.0.3.tar.gz"
  sha256 "e7b1d54180db9961613f5485bf8e2a9fe93d0e58c1bcec0a451b4efe5687c85d"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8975199729672566e15b0ec095cc88b048dcb5eafd1f116debc5c75cd218d404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f897e7e780bffb144439713351420078a7e4c8a1c3dc2eb9bf9ec1bcac044440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8e903fffdf03b3e9fb57478a575f3e7ef2ba60b7b291da23c86b86db25da610"
    sha256 cellar: :any_skip_relocation, sonoma:         "354ecf359f2ba52e90068961d8db04797ac4a513f5bd88277fe8364ff23bb795"
    sha256 cellar: :any_skip_relocation, ventura:        "dde228e56d2bd9634e1d80a2f7d786dab00a056aecc1fbe75e24a8213c5f88b4"
    sha256 cellar: :any_skip_relocation, monterey:       "0600c2432101a001cd67bfe4b7ee0aded6b149f39a314fb9bcd3c3536d600ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75b17c5577dc5a51614d2abd4c612ce9a692c3295fe98561f3f2786197c2d1d1"
  end

  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/54/6f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619e/ujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end

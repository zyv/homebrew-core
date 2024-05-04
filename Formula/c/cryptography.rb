class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/34/c0/d55779ee5c35d77088ca75a721c991dcdd9879e68cde5a3b5b3ac91f0a86/cryptography-42.0.6.tar.gz"
  sha256 "f987a244dfb0333fbd74a691c36000a2569eaf7c7cc2ac838f85f59f0588ddc9"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "76d4ab23b93fe1b1009ca511b5027d61c546cd5d1bd8f396cef2d4f97d51dc75"
    sha256 cellar: :any,                 arm64_ventura:  "cf74a091df7f50095fa60fec91c0a672eb914c304bcbc7266c030414437a33b9"
    sha256 cellar: :any,                 arm64_monterey: "fce46f5b31c66cda0296d05dfdfeca75b9361efd441954fdb0ce6a89545e82ca"
    sha256 cellar: :any,                 sonoma:         "162259b7bc20011aeb5fbdff3f802168adaa0606590349db0060b6629efafd8f"
    sha256 cellar: :any,                 ventura:        "8d208effe9f9c00d4742aa5f7c60f9793a69b6396c5df05e0a8c0c776035d060"
    sha256 cellar: :any,                 monterey:       "b6f337090afce69d557ee4902feb70776f935d229a65329fbf7a7b46f3126629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4a9a18cc0fab2d4197d3f915d37d5c63f4f73ce855640eb32936afc77bb512"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/9d/f1/2cb8887cad0726a5e429cc9c58e30767f58d22c34d55b075d2f845d4a2a5/setuptools-rust-1.9.0.tar.gz"
    sha256 "704df0948f2e4cc60c2596ad6e840ea679f4f43e58ed4ad0c1857807240eab96"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end

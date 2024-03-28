class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.8.tar.gz"
  sha256 "d685e05fc6e56fd7e4e3cacc71f45bd91d90c0455257603ed98a39d2b0f1dd4b"
  license "Zlib"
  revision 1

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6aafd959d5a55d12adf57deef047fa9d3fde83706d1cadaa3a80ea82941c9984"
    sha256 cellar: :any,                 arm64_ventura:  "27001fa186f02615caffd3426000673438f9b0a045cacb644d963650f6838cfa"
    sha256 cellar: :any,                 arm64_monterey: "f05782e62c16bf7af01471fd2c5fe4564c8f7a0f4a1ecc3b2f819faae109c52e"
    sha256 cellar: :any,                 sonoma:         "4e3053cca4d1cd7f16a0be1d134d0c433505995b4462818274fd1f0a080ec77c"
    sha256 cellar: :any,                 ventura:        "fa97d9a613f75b52c8b9925446f06997a541a1804997682eec9d84f7b76c6aca"
    sha256 cellar: :any,                 monterey:       "fb0da4501ea92c1524411a23f5d7622050dcd377296e4f3b5d7755fdf2f76fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be96c45fc2ac7c8b463295a9ba2ab0aa137f842cd08822eda17b727b43ae886"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.12"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d2/e5/7e22ca7201a6b1040aae7787d0fe6cd970311da376a86fdafa5182be1d1b/protobuf-5.26.1.tar.gz"
    sha256 "8ca2a1d97c290ec7b16e4e5dff2e5ae150cc1582f55b5ab300d45cb0dfa90e51"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=#{venv.site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end

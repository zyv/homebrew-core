class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6c/82/7e365a35f02d4e41637807af6a67fdaa2c0664d6fa94df05ca6eee397ac5/PyMuPDF-1.23.25.tar.gz"
  sha256 "eb414e92f08107f43576a1fedea28aa837220b15ad58c8e32015435fe96cc03e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bac1b8014b4cf4c1f810a9a8338acc9192d77cb22af55e507afa3c7d9764e6e9"
    sha256 cellar: :any,                 arm64_ventura:  "8b0569f254cf425251257658b8b95242781ab52983f240238534d4fd04f337a9"
    sha256 cellar: :any,                 arm64_monterey: "cd6ceb9fcbe4b1ca78430d987cf38c70fb9d11080dd6ebf3ff4a6aa106c7ba9a"
    sha256 cellar: :any,                 sonoma:         "a3c563d4c73fc417f01df99001a8174629f6bdf28a1f66bacd496aacb480d9ba"
    sha256 cellar: :any,                 ventura:        "bc7a545b5a9262f8a938155fee169575831c46b01c37c476be193b189e6a87a6"
    sha256 cellar: :any,                 monterey:       "a3f3a94ff60450aa462fed931afb0dd8ef8fbe9f4de7640a8f2562a4884205fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d067608fc6d7265afc8f5c5195e4ca35aa80b40f911f39aaf3736b848d264ee"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.12"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.12"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https://github.com/pymupdf/PyMuPDF/issues/2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include} -I#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      # per 1.23.9 release, `fitz` module got renamed to `fitz_old`
      import fitz_old as fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end

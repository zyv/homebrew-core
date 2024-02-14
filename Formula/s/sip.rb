class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  # upstream page 404 report, https://github.com/Python-SIP/sip/issues/7
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/99/85/261c41cc709f65d5b87669f42e502d05cc544c24884121bc594ab0329d8e/sip-6.8.3.tar.gz"
  sha256 "888547b018bb24c36aded519e93d3e513d4c6aa0ba55b7cc1affbd45cf10762c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd7af2171fcb4ca71524ee632746404bbe297f37ed406043c23dc6a7d878455a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f67d12f087a3f7ea9ec6d90bdbf616774d15202e7687129c9970ec52f4f11050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d82e1e0fc16aa384f8951ea1ebced744eb6ec4de4da638566127ea0136da9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6ad885aba351d9e094b6dfdd07c47e61b17a2e897411df6e6aedfd26c84b378"
    sha256 cellar: :any_skip_relocation, ventura:        "83a66a89d782c6f7890c8387d940b71055b3ad24987fa577cf1ff3c1a9778ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "fd0e462966fcf0e827ad45d65545221bc4b00584f2f920c8e6588991b7b768c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e09b90648563625f3ab1576a4a8277e0b5f386f291b30523777e60fd8ea973"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-ply"
  depends_on "python-setuptools"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
  end

  def install
    clis = %w[sip-build sip-distinfo sip-install sip-module sip-sdist sip-wheel]

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      clis.each do |cli|
        bin.install bin/cli => "#{cli}-#{pyversion}"
      end

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      clis.each do |cli|
        bin.install_symlink "#{cli}-#{pyversion}" => cli
      end
    end
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    EOS

    (testpath/"fib.sip").write <<~EOS
      // Define the SIP wrapper to the (theoretical) fib library.

      %Module(name=fib, language="C")

      int fib_n(int n);
      %MethodCode
          if (a0 <= 0)
          {
              sipRes = 0;
          }
          else
          {
              int a = 0, b = 1, c, i;

              for (i = 2; i <= a0; i++)
              {
                  c = a + b;
                  a = b;
                  b = c;
              }

              sipRes = b;
          }
      %End
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      system "#{bin}/sip-install-#{pyversion}", "--target-dir", "."
    end
  end
end

class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
  sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cac00ccede9d57ed46f041837e8285d06879fdb728ef77264c1f9e226d0f6841"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cac00ccede9d57ed46f041837e8285d06879fdb728ef77264c1f9e226d0f6841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac00ccede9d57ed46f041837e8285d06879fdb728ef77264c1f9e226d0f6841"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b28834c0cd22f5a0b2ef0579131c50d575dfa5b439300b757901f74305c687d"
    sha256 cellar: :any_skip_relocation, ventura:        "4b28834c0cd22f5a0b2ef0579131c50d575dfa5b439300b757901f74305c687d"
    sha256 cellar: :any_skip_relocation, monterey:       "4b28834c0cd22f5a0b2ef0579131c50d575dfa5b439300b757901f74305c687d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d6d2676b7d1d6eba28ce17ce0fa3bd48d0c2c01d9d5d1b4181b09fd02ddca9"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end

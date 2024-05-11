class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/refs/tags/v2.13.tar.gz"
  sha256 "a9f3c9db18e766de6a0fb5d69cbd5b332ab61795c6fc3df2458e4bad1d38ae29"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fbb7ebcdf86e356c5699571498f08da3a081ed6db415106229eeaebc4f2e586"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fbb7ebcdf86e356c5699571498f08da3a081ed6db415106229eeaebc4f2e586"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fbb7ebcdf86e356c5699571498f08da3a081ed6db415106229eeaebc4f2e586"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fbb7ebcdf86e356c5699571498f08da3a081ed6db415106229eeaebc4f2e586"
    sha256 cellar: :any_skip_relocation, ventura:        "5fbb7ebcdf86e356c5699571498f08da3a081ed6db415106229eeaebc4f2e586"
    sha256 cellar: :any_skip_relocation, monterey:       "5fbb7ebcdf86e356c5699571498f08da3a081ed6db415106229eeaebc4f2e586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9edcd8ed569a4d6750a5a9e92250d250365f34d1714cc6ccd24b3884f052d40"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end

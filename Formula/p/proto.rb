class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "d309be4bb5fb50543d1399103cef602311c6c69266979739fb17b6977470ef91"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bac3f0f576acf14c235b3ee7cf5f76915024fa9c5ef18ff47f0c2e2767efc38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fb1c99c1099fa5abafa3c9d01c15953f11d9cf411ba1a2300da83cb0d9ca920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c971199c4c679bd3354466ad493959d21cf3e5beb1508723fd0eede76cd30a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4de29d593fd7f732db0e2adbf0980412a64f554fce677bbc6383cdb65a26ccf0"
    sha256 cellar: :any_skip_relocation, ventura:        "b30ee1501f2b3ea63e3025c68f63cfa0aace8f59c0524dbcacfb349050e14c3d"
    sha256 cellar: :any_skip_relocation, monterey:       "dec333a34d8c6e9d5fcb2f52a084809af4803fa3d45e4d15a2f1183d4fd488c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ab983debed825aa860dba6bfa61a17bccc4de1d9e6731e9b293cf00151599cf"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end

class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/93/87/98299ebfe41687f77ea01bd0e9eba2f43baa30f1b9256345134fd77286d3/borgbackup-1.2.8.tar.gz"
  sha256 "d39d22b0d2cb745584d68608a179b6c75f7b40e496e96feb789e41d34991f4aa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7100fa9d7fc8f028649ae0d87ac0f43261fd29bec22559c766f75fd8397bfc98"
    sha256 cellar: :any,                 arm64_ventura:  "7eea2d82869e8aef5b24d5c916962fa5fdbef89f4792351bbbb01e8ac1e727b7"
    sha256 cellar: :any,                 arm64_monterey: "f0ca05757191f1c0ec833c54cb03d27bb83151ccefb1befd37dcc1452b8a3987"
    sha256 cellar: :any,                 sonoma:         "26b49cb0d0da9ebc32530289853f7d7a8cab0221f20b37334ad9c4b293122d98"
    sha256 cellar: :any,                 ventura:        "e6656f7e859696ff3a0ce5c8e8cd7a4ab36ee7d1f3fac66ec36927facca27441"
    sha256 cellar: :any,                 monterey:       "671e11f2a190941b2743f328f99763f2f22a39db1cf0b403f687c5c6941eb64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52132ddbb9b99149a2c7868bb3a2ddb5485ddc35b82a1ed0cf12e0eba26732c4"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@3"].prefix

    virtualenv_install_with_resources

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end

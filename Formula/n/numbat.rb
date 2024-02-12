class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "e593983a42fe138bf84a2172537c5c1763a8743c65a952fbfd8df67a17f04526"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cd65794c8fdd68b2ce48cb9e517086c0f742d10d19ce3f0fc6053f5024df381"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1944bd431814c9591ec7c40f576f4b1f4bbe83eb56ac07b53ba06109bfd3456e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3b749678d37673f7aa568ff1cc0c2ea0c778e6b45158368b855cd4e7bdeaad9"
    sha256 cellar: :any_skip_relocation, sonoma:         "80ae6c8bde7b15b7a409cc015b0e7b2893b71feb5aed0512d94e1b3e91b9063e"
    sha256 cellar: :any_skip_relocation, ventura:        "1ea917ad3f145844504c8aecb575e779d7222d43eadf7b99517b3887ca8ad2fc"
    sha256 cellar: :any_skip_relocation, monterey:       "a55b86959b751f747e570c259be90e8752688532eb38ebd749beb2c258970a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c067c875f0e69702c3c0797c8ffb7491f9ed6e1d5e909f274fe9a21ce8d5225"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end

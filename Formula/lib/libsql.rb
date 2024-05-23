class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.10/source.tar.gz"
  sha256 "0ca6c971754213712ba1e1cb5e4efac2c2a79de0237bb8c898cc183f0a1af4ef"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59c72c99981a04ce3f44d6cd62e250befe36ddb4cbfe80c3ea65b9a251a9fd24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eae66133e671828cca865c8e087d0e0537fc770964b8046062a5dbb01bbb1310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa445931e08d8c35b7c0544fcebd8e78a3846ebe54d99ab9d5d6a3ffcc22a6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab01fcd42aa0b0d6a3e87bed138c9efb41be30d728bb8184422236e842d6f3c7"
    sha256 cellar: :any_skip_relocation, ventura:        "b21b7e8a58337acd7508d190c48dd76504dddb78fca01b9697105e67f9ef471b"
    sha256 cellar: :any_skip_relocation, monterey:       "d33bef5e08b39604334892dc474183a064abc429e9770a582350c2b608925eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e10a5f2c9578fa6ea16304d35d61ae0fb7e213c0f8f9c0570f3fdc5270ee99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}/sqld" }
    sleep 2
    assert_predicate testpath/"data.sqld", :exist?

    output = shell_output("#{bin}/sqld dump --namespace default 2>&1")
    assert_match <<~EOS, output
      PRAGMA foreign_keys=OFF;
      BEGIN TRANSACTION;
      COMMIT;
    EOS

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end

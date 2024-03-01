class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.23.5/source.tar.gz"
  sha256 "fbc2ab740a025e29a456d636137c8a832ec16ddf1e4f551d278ff2808b1a2828"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

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

class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.24.7.tar.gz"
  sha256 "b8804e5170e7759a7521af03dd7f1a426a6d8fdcd7bf12826a674ddb0df2d4d6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc41ecae14958f0ea090c19fa7d89d891a6073a48c55767eeba9f207ab87de11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73ec7bdd7e6e52b4f6eb90a53b415f92da361a60bf88b855792c82430110d936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b4d25800a440044c53d46ef2726128a34486ab33555c7b544b6b03bfacbb14"
    sha256 cellar: :any_skip_relocation, sonoma:         "e62078cf0366923559e080923dfe51cd6ca715f061b410bd3ba9eefacb98370d"
    sha256 cellar: :any_skip_relocation, ventura:        "60201581e7f9c11c1366e2805ee0645dbf57137ffad2ee3b71e5449bc641d2c0"
    sha256 cellar: :any_skip_relocation, monterey:       "c93d4cd85319c061a3f9ec8b56ea2b57e115d2df91622ded5d17df9f117d7f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47123fba8d28936390f34a207979eb9059c7551f82aac60a62d5e6df86e72f24"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end

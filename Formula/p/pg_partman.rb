class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "3e3a27d7ff827295d5c55ef72f07a49062d6204b3cb0b9a048645d6db9f3cb9f"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cfcffd4b2c6d30cfc4b32e5e740b0b3bb593f85b9279684272b6134f501cc10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1086562e9d3015c962f564893e75623ce23144fc990213c366e18ed2e6b696f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ffc07df2bf1110cae58a294e52dd4dd166c8bd211cd76bb879ac8db5cdc164"
    sha256 cellar: :any_skip_relocation, sonoma:         "79700e8048dcbbd7af6aa59eb11f437eebf44b76b8318138133083103bdb50eb"
    sha256 cellar: :any_skip_relocation, ventura:        "4f1fa43846df7c3a3792ecbda98c32ad146fb53b56dfec2e830a0662d0cb205c"
    sha256 cellar: :any_skip_relocation, monterey:       "03d035cdbd172f29e7546a9e8bf27500d4fc1d951d65efd24939e965b2709977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c036aeda88c24a0935c4d062434e5fffdf3d966d0fc963735db806db01c5060"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    system "make", "install", "bindir=#{bin}",
                              "docdir=#{doc}",
                              "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_partman_bgw'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end

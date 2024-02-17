class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "cc25122ecd5717ac0b14d8cba981265d15d71cd955210971ce6f174eb0036f9a"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "364d0636fcbd90fed0963570eba777c86c74b6ad800f0c81bb8e1670f3ca7188"
    sha256 cellar: :any,                 arm64_ventura:  "dfaa4a894cdfc5f4b24b3e7eb18e269069733ec78f617df08bc2d8fec667a87f"
    sha256 cellar: :any,                 arm64_monterey: "df109d09dbc40c1b91b855c7bb5b42fbbaf74ef9cf445889f81efd3c2f4f4f2e"
    sha256 cellar: :any,                 sonoma:         "8b05f8fc7a92e046ed04c03aee4a8b68b46bffb6103d5d5b1a1ebd73bdd97203"
    sha256 cellar: :any,                 ventura:        "ff1657832310307c91eca34532535ec4f72d9c00fe811a7e034e66085ae87e60"
    sha256 cellar: :any,                 monterey:       "fe005cb58e3b5140b858899c4789b9fc934bdd30940947445af8b96e43124644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0258702322d82d62975b89ebb448fbbb195a55ce941ecc13ee2957de6aa5441"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "postgresql@14"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("postgresql@") }
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "./configure", *std_configure_args
    system "make"
    # Override the hardcoded install paths set by the PGXS makefiles.
    system "make", "install", "bindir=#{bin}",
                              "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end

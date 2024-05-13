class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "23341bb0e8745e8a1d575c2c079f86cfb67522c935d15f98ddb00fc3117cf9e4"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6162a34ce8fd9a1c438ac9c6ee29a79ab3847878bb00e822a1b34dcd6228dd57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf976ddbe70abaac97c82df65921539fb3c858218c6432d6ff67c054c5dacf6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f66532c8deedab676d9f706a056937b8ab1f7f71f7c1879113b25dd840b58a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dea14254a1b46b74a4d6e08cdccf584df8cccfd53df9a4775ca50cda7957d7c"
    sha256 cellar: :any_skip_relocation, ventura:        "43d0503f480315342ba84e0ca18dd77266de425b33b3939d6ab1e33ce786b1c0"
    sha256 cellar: :any_skip_relocation, monterey:       "17df2f8110793edf882bce0b8dd34bb8f3bce7c0fbc22a580f716f7599beaf97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7952d3644d4a1b1338f57c55f0135d3b693858f6aa7b5d7476f3de2d5ceb66"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~EOS
      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      user:
        name: "doltgres"
        password: "password"

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    EOS

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    output = shell_output("#{psql} -h 127.0.0.1 -p #{port} -U doltgres -c 'SELECT DATABASE()' 2>&1")
    assert_match "database() \n------------\n doltgres\n(1 row)", output
  end
end

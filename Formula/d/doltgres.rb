class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "26aa819db16975a9ca5b4560855949f435087f8d36cf50a69c383320e6212a91"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14b267eb5dfd3b6f3e9529b5bd6fb7b93bf68eb2e91674aa3e6f62f15bc3ac00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50431d23fa2f72d769b4c839191c25b7777399df2a391988f3071e40b4272f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ecd36de72cd6d1c55af264e2c82e391b40d51c895534c520a263171f05dd730"
    sha256 cellar: :any_skip_relocation, sonoma:         "402139cbe5b6231cfbc889ba7fa184285e4d9403dced0cc65ef226ac480bf266"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a921b64c2d2b9c1a21045d996e17e90d8ce42be9ebadc770555bd2f4865ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "788deb7024c7e19bd6f46dcbd4b5355a12a713863e8d1e00aa86597dbf581c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c8b8701cc95fad2ee6b29b764d41f2dc40f3792ba39ae721ffa2631978c82c"
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

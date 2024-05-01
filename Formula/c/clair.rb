class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/refs/tags/v4.7.4.tar.gz"
  sha256 "1c90235a76015a882f547c298e713526b93425a02fc7f02566fa324dc237d6c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f1dd5f975b4fbb95ad6295794cce39a4990c1410a51802fa7e60a5f23d7482a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7141497e5ab91fc3f9078cc6ffae0abcb61ec6a3f8e9cbb99c08b8ada245a28b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04434618dff6a1ae39495c59135ce37aaa7add46de7e463706cdbe32017f342a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0af1794c1f2ae85802df3b7054e5c4b8071ab13c0d47ea32197047bae97fe8b9"
    sha256 cellar: :any_skip_relocation, ventura:        "82ca298b6fea6844fd56d30e01108df1d0999eaabc74494d19337dcff141dc89"
    sha256 cellar: :any_skip_relocation, monterey:       "f19e38e5208e3e044859a33a6e7f7003c4d783ba9558ffe8d6b4f1984eaece7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3dc1aaac1944193d494b58e7911cfe8e19c534029f91c5f870237bc830104c"
  end

  depends_on "go@1.21" => :build # use "go" again when https://github.com/quay/clair/pull/1942 is released

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    http_port = free_port
    db_port = free_port
    (testpath/"config.yaml").write <<~EOS
      ---
      introspection_addr: "localhost:#{free_port}"
      http_listen_addr: "localhost:#{http_port}"
      indexer:
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      matcher:
        indexer_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      notifier:
        indexer_addr: "localhost:#{http_port}"
        matcher_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
    EOS

    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end

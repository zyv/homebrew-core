require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.6.tgz"
  sha256 "18038f8507293bf1539a0bb0b25f635e0284c4b26adc73e693c22acc6c8e2df6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3409e6bf4db00bf7c2bbdd76ed8affe51f86839e733f576567eaec0ae23e6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3409e6bf4db00bf7c2bbdd76ed8affe51f86839e733f576567eaec0ae23e6bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3409e6bf4db00bf7c2bbdd76ed8affe51f86839e733f576567eaec0ae23e6bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bb097b82e2f49b709b1ce9a55096c6eff95e51ae5a71a50cc6d46a49fda3bec"
    sha256 cellar: :any_skip_relocation, ventura:        "4bb097b82e2f49b709b1ce9a55096c6eff95e51ae5a71a50cc6d46a49fda3bec"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb097b82e2f49b709b1ce9a55096c6eff95e51ae5a71a50cc6d46a49fda3bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1263309813ab03a3f8c9db618e9bad49c2034c3554ed157784d2cee571fe3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~EOS
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    EOS

    expected_dbml = <<~EOS
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end

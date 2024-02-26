require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.2.0.tgz"
  sha256 "70b2b4e084b8d22778c71f1cc40d0b7b98efdeafd2253726ba0d50fe33f820b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0481188cb74a54559977fc67d4ea6646c5ce133983fcb59c002abf64ca231e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0481188cb74a54559977fc67d4ea6646c5ce133983fcb59c002abf64ca231e5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0481188cb74a54559977fc67d4ea6646c5ce133983fcb59c002abf64ca231e5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c3bad8fe627eec575c1e5a0a81f20de605463809a568d0d5910b08143f81d7c"
    sha256 cellar: :any_skip_relocation, ventura:        "3c3bad8fe627eec575c1e5a0a81f20de605463809a568d0d5910b08143f81d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "3c3bad8fe627eec575c1e5a0a81f20de605463809a568d0d5910b08143f81d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76dd7a766341c84d9d16fd206c51826af415554be00277f492cfc78a8c38b2eb"
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

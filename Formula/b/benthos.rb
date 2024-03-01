class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.25.1.tar.gz"
  sha256 "0a25fd477bb5d10591347cbc087703c85a98cdfa97477e0e56c6b1d390cf50b5"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e2a6e85cf9be17ab4a1867013a30f66c5d9f1e6369c1fe86fc0d792e0621939"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf23d7511fdb6565ab3e0c1eaee26823cd3315ff0808cfab6b88027f20bebb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc49ef8dc539db884c6b5271ab95749109cc2f98d04b5dc9f4368e254c63b02"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4044b232481b8e447ce573404ca2d310ddd003676c3af63f06b77f714354922"
    sha256 cellar: :any_skip_relocation, ventura:        "12713c1f6668f882f37833e1216ae83691e7042acf8bd00e54e8864c9c17b7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "6b264dd2592e3a4e0ea45d85da471fcaaaa65ef91d47987c6761907a3dcf382a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ca1133627f3e5174f64267be3c1498a8adee91015bdd6afcfe8f08956d8b89"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end

require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-8.1.0.tgz"
  sha256 "aeb9483d5f4e2e56b21371f65a57545d93365634be730988b0d808d038d0ea69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b1533b0a268b7ab5090092aff674bec862967caea8f52d0b67d087d7f197edb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b1533b0a268b7ab5090092aff674bec862967caea8f52d0b67d087d7f197edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b1533b0a268b7ab5090092aff674bec862967caea8f52d0b67d087d7f197edb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed0368ee944b7c21d4447eaf81a94057e504557ca750f792aec1bf8f08422ec5"
    sha256 cellar: :any_skip_relocation, ventura:        "ed0368ee944b7c21d4447eaf81a94057e504557ca750f792aec1bf8f08422ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "ed0368ee944b7c21d4447eaf81a94057e504557ca750f792aec1bf8f08422ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1533b0a268b7ab5090092aff674bec862967caea8f52d0b67d087d7f197edb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end

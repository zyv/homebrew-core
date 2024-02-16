class Yamllint < Formula
  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/da/06/d8cee5c3dfd550cc0a466ead8b321138198485d1034130ac1393cc49d63e/yamllint-1.35.1.tar.gz"
  sha256 "7a003809f88324fd2c877734f2d575ee7881dd9043360657cc8049c809eba6cd"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37391f7213a341dc1dcd90f573736bba055ebe32d4718b7170ae870b3970a720"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "196b7ed448b74a6099810ab9b9208d7b9e5031a5c4c409264f11c1958e738df4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e781c3620543c2d9e2f009650bff8b8e56e89dd2d60a17ab988186d79d35c1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e979694c2572ba0ffcc4e6ef47c0f9d5b177c75aa4d6c6c98f2dcd3863dfbc63"
    sha256 cellar: :any_skip_relocation, ventura:        "672a118decd5b105fe8bb7dcd2227f19530346c4fb1370fb8abba10f78d4feb6"
    sha256 cellar: :any_skip_relocation, monterey:       "e67394bca2b1abf139e2d919106ea1d9926a45b4b4830165ce6561ad04e85988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d26246f3bac27e10c35c756bccf3059a81103fb53eebbfa9352098833b9dded"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-pathspec"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end

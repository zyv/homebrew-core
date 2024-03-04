class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ecc26b1c83b8d2df1c8a46b2cf5e5f2a7bfe8b530c00e9344fdfb11d8343ffcd"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b50965fa2e05ee16d5a05a6adf893a00d7138af4467962769f5dfaf09ffad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53b50965fa2e05ee16d5a05a6adf893a00d7138af4467962769f5dfaf09ffad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b50965fa2e05ee16d5a05a6adf893a00d7138af4467962769f5dfaf09ffad0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f451b76a60b9180dbad41e6155023251fdf347fd53650f7400282babbf4dc81f"
    sha256 cellar: :any_skip_relocation, ventura:        "f451b76a60b9180dbad41e6155023251fdf347fd53650f7400282babbf4dc81f"
    sha256 cellar: :any_skip_relocation, monterey:       "f451b76a60b9180dbad41e6155023251fdf347fd53650f7400282babbf4dc81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e48015bb1be45cd723513f9931c29730f259b8874dec02f81f465bd6cff3be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end

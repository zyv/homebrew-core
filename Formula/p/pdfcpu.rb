class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e36b1b03ff77fc2b9aa7ab4becfd2e0db271da0d5c56f6eb9b9ac844a04a00c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bef88342b519a720e971e6a348734e9f76f5001a2916d386dfeb96a9d192a051"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7b03bb8f8bd208e05b23647419d7c1078d9f62c8ae74da3cd429b87ae605c11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366678b43a0dcbc82641ccf322bc5b91966e704ed8145dfaa9a0255c1537aadd"
    sha256 cellar: :any_skip_relocation, sonoma:         "590d622c260a8ab94dc5f8e1ecb70ca8d1656712870242c39a9693e492602f37"
    sha256 cellar: :any_skip_relocation, ventura:        "84583464f617e6db173e5244f1132bd4222acfacd896276ed2b51eab29a870c9"
    sha256 cellar: :any_skip_relocation, monterey:       "a01c7c0108330b0358f850b3e971597a8eef6352791389b901436b5abf472d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c595aec73d201c47fdf745c3e97384d281a2322b4af4d9c095bc85d7d7b9db"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      installing user font:
      Roboto-Regular
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end

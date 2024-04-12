class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.39.tar.gz"
  sha256 "b225891b94bbdb549ddbc9ffe838ad87f73ef7cc79934e3e23969bb1220eafd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ab32872672c6705883ac8c6400cf60558ec19991eb3065ec7e82d07fe11f2bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e343aba5648be78fe8d52ca599abeec04820a65eb4ac076eebc6d406093cf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "372dd9a9fa66f147059cc1f9b1e187f75ad66954748fe6d20337e5d9ab52ede2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e07d816503e7e1b660071827c5ef849d882361931fe7d628513cd9f8f2429882"
    sha256 cellar: :any_skip_relocation, ventura:        "3dbd1bcf38b5f9df2205268a43943db9789b2b05c3c694239262746f41267a94"
    sha256 cellar: :any_skip_relocation, monterey:       "aeae76833647007726d4996f84ecef4a5c6ba9c74b117d0e1eb7472729e7e597"
    sha256                               x86_64_linux:   "255accd2af680d533284f44af16d56abb70ab9eabd360bd3dbe84c056c2b4a49"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource "homebrew-test_log" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2024.04.14/test.xcactivitylog"
      sha256 "3ac25e3160e867cc2f4bdeb06043ff951d8f54418d877a9dd7ad858c09cfa017"
    end

    resource("homebrew-test_log").stage(testpath)
    output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    assert_match "Target 'helloworldTests' in project 'helloworld'", output

    assert_match version.to_s, shell_output("#{bin}/xclogparser version")
  end
end

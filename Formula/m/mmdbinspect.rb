class Mmdbinspect < Formula
  desc "Look up records for one or more IPs/networks in one or more .mmdb databases"
  homepage "https://github.com/maxmind/mmdbinspect"
  url "https://github.com/maxmind/mmdbinspect/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7031c9df103b78f6cc1e441dec7bff80743bae79935bf0694a8d9c1f2d0d6cab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/maxmind/mmdbinspect.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mmdbinspect"
  end

  test do
    resource "homebrew-test-data" do
      url "https://raw.githubusercontent.com/maxmind/MaxMind-DB/507c17e7cf266bb47bca4922aa62071cb21f6d06/test-data/GeoIP2-City-Test.mmdb"
      sha256 "7959cc4c67576efc612f1cfdea5f459358b0d69e4be19f344417e7ba4b5e8114"
    end

    testpath.install resource("homebrew-test-data")

    output = shell_output("#{bin}/mmdbinspect -db GeoIP2-City-Test.mmdb 175.16.199.1")
    assert_match "Changchun", output
  end
end

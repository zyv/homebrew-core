class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.11.3.tar.gz"
  sha256 "917fa5fb26773ac4653fa89b62f9d9f98272071b33660145c2dfd48c17a5368a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "175927a06fbeb134bf20f3f5724a2b59a823b9fd6947b9362433c56b0f62197b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "238019eaa311c7f2b77b78ab08e38548cfb5ebd90e2dea8cc087d337b9ca0b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2001c90642897d2fe41779f2568d7c4902b6ea4d31a0c8612cd1609597a3504"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaa0b319ae1c834a86c3cf90a8f990532ee7039ecded5c33e9508b2c39ecd33b"
    sha256 cellar: :any_skip_relocation, ventura:        "a18bbfa9ca13aa5e5b1a9490d4bf8097564c79ea4f721a5dcd1fe18d2d9eb2cf"
    sha256 cellar: :any_skip_relocation, monterey:       "a826401c8df5b802c4a607e0828c8996307631cdc064d0b46b505eb680f84bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eac882b69e30a4de9bcc16545c4a5a0c922567e00f556395bba47fd0d2a675c"
  end

  depends_on "rust" => :build

  def install
    # skip default features like snmalloc which errs on ubuntu 16.04
    system "cargo", "install", "--no-default-features",
                               "--features", "rustls",
                               *std_cargo_args(path: "roapi")
  end

  test do
    # test that versioning works
    assert_equal "roapi #{version}", shell_output("#{bin}/roapi -V").strip

    # test CSV reading + JSON response
    port = free_port
    (testpath/"data.csv").write "name,age\nsam,27\n"
    expected_output = '[{"name":"sam"}]'

    begin
      pid = fork do
        exec bin/"roapi", "-a", "localhost:#{port}", "-t", "#{testpath}/data.csv"
      end
      query = "SELECT name from data"
      header = "ACCEPT: application/json"
      url = "localhost:#{port}/api/sql"
      assert_match expected_output, shell_output("curl -s -X POST -H '#{header}' -d '#{query}' #{url}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

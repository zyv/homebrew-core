class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "98a4317316a94e77f567e774ebe8b5e651089b4c4abcb77bc5ae5ca59321ad64"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a522f9b00c3837f81c3aa8ba9b525672c17755f7ee13f668ee81c060cdd6296"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68b3df5867f738e7fe11600ed9cde69fd483e6df3f1a3c469fbeb45f6394b893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5791018f791bf3aa4d69261b980e3c8559407b07ef1fb1d231af80e809304f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f37b98d63549ab62dede8412bd3fa1293d10e54cdde639a417cfbed0542ecc07"
    sha256 cellar: :any_skip_relocation, ventura:        "7d5a50e35aff63779c44f2569e1ab7aa189c5bdc5dcf3545507a87af2774f9f4"
    sha256 cellar: :any_skip_relocation, monterey:       "795ba9f515ade92c6f6d949bbc9e153a2be91804a7bd37a16a8f6ab804648052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7983453fe8cd4726259480cf175d9d2b2c709c230346aa2b1e397ff0885eaa6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end

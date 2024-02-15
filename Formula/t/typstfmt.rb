class Typstfmt < Formula
  desc "Formatter for typst"
  homepage "https://github.com/astrale-sharp/typstfmt"
  url "https://github.com/astrale-sharp/typstfmt/archive/refs/tags/0.2.8.tar.gz"
  sha256 "0c884ea06a8f1d04fa12ea582f11b3520e09c337fb42855b3b49175f1e4b8a57"
  license one_of: ["MIT", "Apache-2.0"]
  head "https://github.com/astrale-sharp/typstfmt.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstfmt", "Hello.typ"

    # https://github.com/astrale-sharp/typstfmt/issues/155
    # assert_match version.to_s, shell_output("#{bin}/typstfmt --version")
  end
end

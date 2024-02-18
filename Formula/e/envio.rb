class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https://envio-cli.github.io/home"
  url "https://github.com/envio-cli/envio/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "d0009a19dc081d3e7e1b36e8e9fdc29f675d8ac80ddd08565777e6b7d7a99bb1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/envio-cli/envio.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Setup envio config path
    mkdir testpath/".envio"
    touch testpath/".envio/setenv.sh"

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

    begin
      output = shell_output("#{bin}/envio create brewtest -g #{testpath}/.gnupg/trustdb.gpg", 1)
      assert_match "Profiles directory does not exist creating it now..", output
      assert_predicate testpath/".envio/profiles/brewtest.env", :exist?

      output = shell_output("#{bin}/envio list")
      assert_empty output

      assert_match version.to_s, shell_output("#{bin}/envio version")
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

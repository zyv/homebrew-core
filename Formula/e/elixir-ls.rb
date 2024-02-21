class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "f03f1bb0eb28d60dc9aa2f4d5114018943573f344a0e4df076760aaeb246bd67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1c89f773c0bfe3dd2f61d41c8fc7edd1c2481655d8330e5ea99d32e50d4d938"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release2", "-o", libexec
    libexec.glob("*.bat").map(&:unlink)

    bin.install_symlink libexec/"language_server.sh" => "elixir-ls"
  end

  test do
    assert_predicate bin/"elixir-ls", :exist?
    system "mix", "local.hex", "--force"

    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end

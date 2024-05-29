class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/refs/tags/1.9.0.tar.gz"
  sha256 "af453a39935a4cb64dbf891f5487de9f0c2668375f296352730af1cb2d425df6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a10ab650965b6f6e7d349917cc5f5e4d4af273c2386576b82129a79fcdae8547"
  end

  uses_from_macos "python"

  def install
    if OS.linux? || MacOS.version >= :catalina
      rewrite_shebang detected_python_shebang(use_python_from_path: true), "nodeenv.py"
    end
    bin.install "nodeenv.py" => "nodeenv"
  end

  test do
    system bin/"nodeenv", "--node=16.0.0", "--prebuilt", "env-16.0.0-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-16.0.0-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v16.0.0", shell_output("node -v")
  end
end

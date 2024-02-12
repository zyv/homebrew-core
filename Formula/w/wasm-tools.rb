class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.60.tar.gz"
  sha256 "397fdfbcc3d1352291250d89d5caad8c8d50a6b1d22d14ed7b74a247ce08ff31"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc2c11ac3a3e9068fad3c28c3b0d44744ca5009df55e5e18ee3ef6ba3b116713"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71df29981d1b03b0fc9b80e77edbd85d106aa8229a80089eaf4533fe84f020b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15641b9b00a9bf54f2d67acad7763f6f2a2603fe4f1350ea3c44a7d9619f5a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b006513bce60664113d53e93db779e3b19cca074f05ab9aa3eacd0fac60ec278"
    sha256 cellar: :any_skip_relocation, ventura:        "45cb584a057824e8d67815820ad460bfacedfa1a73c70e5100f375aa69ed54ab"
    sha256 cellar: :any_skip_relocation, monterey:       "71e3677050c4a4844cdbbc647630a2d42704ae6f2f7bfe2b6f7f3a3101732380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b233aa5e36cdc58ea77a11130e91c3e8b50367bb5112daaf9bbffef978da35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end

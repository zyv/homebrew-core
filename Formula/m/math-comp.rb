class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66379c29b12dc6f562e9585acbeb4142bee6db14d83fcc527893bc58c6211c84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58fd08d2af21352002fb658f616a2c8d0f988d4406df69657f45b50ff3674c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "797de6bb4bbea997cf414016713da50500eec597a02bf67435790459ad42d2bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c53ebdc42550b17ae344a716831ca21bc2fb1b08f4ee64f709d2f659d865e6d"
    sha256 cellar: :any_skip_relocation, ventura:        "1191f9038fc3cc50464f67c2e952f72246eb0e1b96326cacc8cfb0887d964869"
    sha256 cellar: :any_skip_relocation, monterey:       "c861c3eee22ed6e5b01ed97255157a8a66f0bb226a953feedd024d4a3167faea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c1184a7077b4595c361bcf6fa89f5f008923636f72a47fb8b145df3faa57d1"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    coqlib = "#{lib}/coq/"

    (buildpath/"mathcomp/Makefile.coq.local").write <<~EOS
      COQLIB=#{coqlib}
    EOS

    cd "mathcomp" do
      system "make", "Makefile.coq"
      system "make", "-f", "Makefile.coq", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"
      system "make", "install", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"

      elisp.install "ssreflect/pg-ssr.el"
    end

    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    coqc = Formula["coq"].opt_bin/"coqc"
    cmd = "#{coqc} -R #{lib}/coq/user-contrib/mathcomp mathcomp testing.v"
    assert_match(/\Atest\s+: forall/, shell_output(cmd))
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/releases/download/V8.19.0/coq-8.19.0.tar.gz"
  sha256 "17e5c10fadcd3cda7509d822099a892fcd003485272b56a45abd30390f6a426f"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "709a6613c6569951c7889dc2103c6d1c7c036b6dacdb2608b63ef9779a9a0cde"
    sha256 arm64_ventura:  "27bd72f63d9dd93aa9d1557a00ad2bbfa0e6b282f6d2f87d67d5dab884f03648"
    sha256 arm64_monterey: "79e5142487fe49356360877cf51bdaf26a0165439d266a06da219f75849326d9"
    sha256 sonoma:         "384adbfe9bc3d85e053e95872d93ed34715d9918c0338d3be879bd736263f54f"
    sha256 ventura:        "a5ba5b159aa6171568a73745fab0c0e8f8904c5c3b3c30aa3db5185ce23a6cee"
    sha256 monterey:       "a5d4ae60a2042c4d28bf0e9b85ca8b7be99e8ece75a252315d556facae44d52e"
    sha256 x86_64_linux:   "9354a56b2c31bbbcf55952dc52a1e959b429d7ae0d5d168cdd8d76a1487c2d21"
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", "coq-core,coq-stdlib,coqide-server,coq"
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "coq-core",
                              "coq-stdlib",
                              "coqide-server",
                              "coq"
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.micromega.Lia.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.micromega.Lia.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; lia.
      Qed.
    EOS
    system bin/"coqc", testpath/"testing.v"
  end
end

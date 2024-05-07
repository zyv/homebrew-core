class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e81be1e94dafba5e4a6f08b7f3a530c75926740d47e3a6b198687cd132630b6d"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def install
    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
      -DENABLE_LTO=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The artifact will be renamed to `kuzu` in CMakeLists.txt for the next
    # release of Kuzu. This is a temporary workaround and will be removed when
    # the next release is out. See: https://github.com/kuzudb/kuzu/issues/3458
    bin.install_symlink bin/"kuzu_shell" => "kuzu"
  end

  test do
    db_path = testpath/"testdb/"
    cypher_path = testpath/"test.cypher"
    cypher_path.write <<~EOS
      CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name));
      CREATE (:Person {name: 'Alice', age: 25});
      CREATE (:Person {name: 'Bob', age: 30});
      MATCH (a:Person) RETURN a.name AS NAME, a.age AS AGE ORDER BY a.name ASC;
    EOS

    output = shell_output("#{bin}/kuzu #{db_path} < #{cypher_path}")

    expected_1 = <<~EOS
      ----------------------------------
      | result                         |
      ----------------------------------
      | Table Person has been created. |
      ----------------------------------
    EOS
    expected_2 = <<~EOS
      ---------------
      | NAME  | AGE |
      ---------------
      | Alice | 25  |
      ---------------
      | Bob   | 30  |
      ---------------
    EOS

    assert_match expected_1, output
    assert_match expected_2, output
  end
end

class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.7.0/pinocchio-2.7.0.tar.gz"
  sha256 "fbc8de46b3296c8bf7d4d9b03392c04809a1bca52930fab243749eeef39db406"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4225c920ce4da6c69e0c250573d7ea901bf7d08606d3621f8c2d251f6beed382"
    sha256 cellar: :any,                 arm64_ventura:  "3625ab5afaeb3f74c6f2c06608dea16c29ba1b1535dbf1e480bc0c4ea5b3e613"
    sha256 cellar: :any,                 arm64_monterey: "57bf405cad6c48862a8b701250392864391583818c7857ea179b1920f9ecb681"
    sha256 cellar: :any,                 sonoma:         "a52895cf7dfde9de4416546e6f8b2fc4a4e72450f8261f7a27a6714bdc5b4aa2"
    sha256 cellar: :any,                 ventura:        "31c92723f2a035782ed65e23031054021c7112e24fdd32abe93a42f09f9ce15c"
    sha256 cellar: :any,                 monterey:       "19084bbf232327deac104b43f2950f4b1abeb4af4a2846e29043cebcef54e374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e45984dacaa80a5ce790c2599395f717bc9559dccc061c2274daa29b3c33c0d5"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.12"
  depends_on "urdfdom"

  def python3
    "python3.12"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end

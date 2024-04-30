class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8c/2b/6fe0409501798abc780a70cab48c39599742ab5a8168e682107eaab78fca/PyQt6-6.6.1.tar.gz"
  sha256 "9f158aa29d205142c56f0f35d07784b8df0be28378d20a97bcda8bd64ffd0379"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "70da9c98f162ce4f9f42b871b1951b9414c60bc88d7f6cd256791ad41a9a9de5"
    sha256 cellar: :any,                 arm64_ventura:  "a926afd8822bace68785390696618a6354d6b39baf5a276d9e65ceafe9c8db53"
    sha256 cellar: :any,                 arm64_monterey: "835db2f635626191030c76e1adc1639bb05609f8e8e02a3d7511ec26299393ad"
    sha256 cellar: :any,                 sonoma:         "fbf38e8652acac6609e3c29aa05bca2d131dac3896bef6ed983294e9c4f20635"
    sha256 cellar: :any,                 ventura:        "e5f7ef5e3d21c6c85f0c24d93cef5aa72748836e1def444ff45b90e96ffdac8d"
    sha256 cellar: :any,                 monterey:       "61e6faf499e80d1aa952381a0b4d9bc8920a5749c5cee3c7afbcd08835567dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0635af95e0ed446fdea11006a8b83d871ab720738a795b17b8f0bad076c44c"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/3c/3f/7909d2886f500b9512a544c46c4e3e213a7624229a1dd1f417b885dedd6e/PyQt6_3D-6.6.0.tar.gz"
    sha256 "372b206eb8185f2b6ff048629d3296cb137c9e5901b113119ffa46a317726988"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/ef/7e/88d25f0c34a795744d8b87d0bdb5c76ce0e28f4070568e763442973c3e2c/PyQt6_Charts-6.6.0.tar.gz"
    sha256 "14cc6e5d19cae80129524a42fa6332d0d5dada4282a9423425e6b9ae1b6bc56d"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/e1/ca/8b4a4ba040ecfa4fa0859ee8dcb99095f19c4ca5e42255821c9a6feafde8/PyQt6_DataVisualization-6.6.0.tar.gz"
    sha256 "5ad62a0f9815eca3acdff1078cfc2c10f6542c1d5cfe53626c0015e854441479"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/c4/db/b4a4ec7c0566b247410a0371a91050592b76480ca7581ebeb2c537f4596b/PyQt6_NetworkAuth-6.6.0.tar.gz"
    sha256 "cdfc0bfaea16a9e09f075bdafefb996aa9fdec392052ba4fb3cbac233c1958fb"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/98/23/e54e02a44afc357ccab1b88575b90729664164358ceffde43e4f2e549daa/PyQt6_sip-13.6.0.tar.gz"
    sha256 "2486e1588071943d4f6657ba09096dc9fffd2322ad2c30041e78ea3f037b5778"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/49/9a/69db3a2ab1ba43f762144a66f0375540e195e107a1049d7263ab48ebc9cc/PyQt6_WebEngine-6.6.0.tar.gz"
    sha256 "d50b984c3f85e409e692b156132721522d4e8cf9b6c25e0cf927eea2dfb39487"
  end

  # Backport support for `qt` 6.7.0 API changes
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/50173dde32f39f63617ece5d4cad2a616027a506/pyqt/qt-6.7.0.patch"
    sha256 "2e1df66b5d6ad338269368bc3778f27ed77f66be891613f7c567fbdac2197f6d"
  end

  def python3
    "python3.12"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    sip_install = Formula["pyqt-builder"].opt_libexec/"bin/sip-install"
    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system sip_install, *args

    resource("pyqt6-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~EOS
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        EOS
        system sip_install, "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_predicate share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}"), :exist?
  end
end

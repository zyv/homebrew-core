class Phodav < Formula
  desc "WebDav server implementation using libsoup (RFC 4918)"
  homepage "https://gitlab.gnome.org/GNOME/phodav"
  url "https://gitlab.gnome.org/GNOME/phodav.git", tag: "v3.0", revision: "d733fd853f0664ad8035b1b85604c62de0e97098"
  license "LGPL-2.1-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "libsoup"
  depends_on "xmlto"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libphodav/phodav.h>
      #include <glib.h>
      int main() {
        GFile *root_dir = g_file_new_for_path("./phodav-virtual-root");
        GFile *real_dir = g_file_get_child(root_dir, "real");
        PhodavVirtualDir *root = phodav_virtual_dir_new_root();
        phodav_virtual_dir_root_set_real(root, "./phodav-virtual-root");
        PhodavVirtualDir *virtual_dir = phodav_virtual_dir_new_dir(root, "/virtual", NULL);
        phodav_virtual_dir_attach_real_child(virtual_dir, real_dir);
        PhodavServer *phodav = phodav_server_new_for_root_file(G_FILE(root));
        g_assert_nonnull(phodav);
        g_object_unref(virtual_dir);
        g_object_unref(real_dir);
        g_object_unref(root_dir);
        g_object_unref(root);
        SoupServer *server = phodav_server_get_soup_server(phodav);
        g_assert_nonnull(server);
        g_object_unref(phodav);
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].lib}/pkgconfig"
    system ENV.cc, "test.cpp",
                   *shell_output("pkg-config --libs --cflags libphodav-3.0").chomp.split,
                   "-o", "test"
    system "./test"
  end
end

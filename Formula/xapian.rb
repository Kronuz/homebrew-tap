class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  version "1.5-kronuz"
  url "https://github.com/Kronuz/xapian/archive/master.tar.gz"
  sha256 "b4071db8f1d87ffc90e30758d1c6afe57bb3efc3be825194704c78433cec5e9e"
  head "https://github.com/Kronuz/xapian.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "b6e0978d3cb0ebaa91defb32471bdb5ede93acc1c62edfccba1e8846453db1be" => :mojave
  end

  skip_clean :la

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    chdir "xapian-core" do
      system "./preautoreconf"
      system "autoreconf", "--force", "--install", "-Im4", "-I/usr/local/share/aclocal"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-documentation",
                            "--enable-maintainer-mode",
                            "--disable-silent-rules",
                            "--program-suffix=''",
                            "--prefix=#{prefix}",
                            "CXXFLAGS=-O3 -DFLINTLOCK_USE_FLOCK -DXAPIAN_MOVE_SEMANTICS",
                            "LDFLAGS=-O3"
      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end

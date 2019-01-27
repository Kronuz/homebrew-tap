class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  version "1.5-kronuz"
  url "https://github.com/Kronuz/xapian/archive/master.tar.gz"
  sha256 "c5f5bbf311444d623815e38f1da98dcec253cab199beaa73d04c02f5cb2f4a54"
  head "https://github.com/Kronuz/xapian.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "ecaca1af78af9e0cf3eae44f3a7a5aa2111d8244228886e75c0227c90f51b053" => :mojave
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

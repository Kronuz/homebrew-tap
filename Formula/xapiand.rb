class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "https://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v0.39.5.tar.gz"
  sha256 "28ffa612997a2e8c270bda1a20b5c003b57381cf74c1738647e2dc237898f87e"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "91db880c5b8fbf3f107f2b118ce7502d953e89f485c62b9249170ea0b9d6cc88" => :high_sierra
    sha256 "b636e8915d2a077f49d81a3d5819997df6c96aef842484f8d60d753e85d0b787" => :mojave
  end

  depends_on "icu4c"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND", "-DROOT=#{HOMEBREW_PREFIX}", "-DPACKAGE_HASH=#{ENV['HOMEBREW_PACKAGE_HASH']}", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  def post_install
    (var/"run").mkpath
    (var/"db/xapiand").mkpath
    (var/"log").mkpath
  end

  test do
    system bin/"xapiand", "--version"
  end
end

class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "https://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v0.40.0.tar.gz"
  sha256 "9a935c533c78728c7dffd4c46e584b37d74a617c2fd58cf4f7a4cea88a6ec4d2"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "ad0d50b6d2ebe17a5319a8d42c2a19be0eaa414b245422ce22e920d3f2f41c55" => :high_sierra
    sha256 "efa94bb3234cd980a3dd742c21c7df9ba5877f2e40ac4fd6b19f705973c0cacf" => :mojave
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

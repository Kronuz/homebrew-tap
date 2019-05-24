class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "https://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v0.23.0.tar.gz"
  sha256 "02613ef44270ff2e22f46bb341b46dacde33c6546eb62b7034ff2c7ed3dcebc4"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "870b5089f68999b3805bba0c85e9ef5fbe5626a9f7813a3b90703b540756368a" => :mojave
    sha256 "b782a2717599317dd1f1e5b760b84d86d90d409093ad25521d77138bfb92eabf" => :high_sierra
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

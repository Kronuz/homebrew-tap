class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "https://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v0.39.0.tar.gz"
  sha256 "811f6ea5b74e99510d423b6443e6057ac2beb4d5c58640221f01f5ddf1c2d9bd"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "e8b7273a91d38d646af8980d0dd5d384e7c23294a38dac44fba9f7e1a63ff8e1" => :high_sierra
    sha256 "6c535843fb8c3fc544cf96d925087e8ffc2a044b9ad49da9967b8010b8506b01" => :mojave
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

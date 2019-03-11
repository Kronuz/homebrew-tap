class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "https://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v0.12.1.tar.gz"
  sha256 "7c1a721891f64f8ec527433e40ede3c84c299dd587f58b4ddb2de8505bb9fb03"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "5226914afce7c34ea6f4cd0976a06d03e17b3aa4a37664430308089a7fd8b83a" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND", "-DROOT=#{HOMEBREW_PREFIX}", *std_cmake_args
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

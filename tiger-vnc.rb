class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.7.0.tar.gz"
  sha256 "4aa704747b4f8f1d59768b663c488fa937e6783db2a46ae407cd2a599cfbf8b1"

  bottle do
    sha256 "6198b9741a6c14df3e0fc0229bd1c7bc285a978bbfed1cec41905515328c3df8" => :el_capitan
    sha256 "9a2060f96429fff0b84a683c6fe8c007bd89a674391033bf7bed689a6296de03" => :yosemite
    sha256 "8a2204f2edac7580689c63ef97254bb82caf010ef960cec8cb709005404ab823" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end
end

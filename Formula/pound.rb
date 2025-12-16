class Pound < Formula
  desc "Reverse proxy, load balancer and HTTPS front-end for web servers"
  homepage "https://github.com/graygnuorg/pound"
  url "https://github.com/graygnuorg/pound/releases/download/v4.19/pound-4.19.tar.gz"
  sha256 "11bd62439c4e916488af2956f388fe016fda3ddb3f33e7bf3b666d29d7fd24ca"
  license "GPL-3.0-or-later"

  depends_on "pkgconf" => :build
  depends_on "adns"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  def install
    args = []
    if OS.mac?
       args << "--without-fsevmon"
    end

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"pound.cfg").write <<~EOS
      ListenHTTP
        Address 1.2.3.4
        Port    80
        Service
          Host "www.server0.com"
          BackEnd
            Address 192.168.0.10
            Port    80
          End
        End
      End
    EOS

    system "#{sbin}/pound", "-f", "#{testpath}/pound.cfg", "-c"
  end
end

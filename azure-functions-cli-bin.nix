{ stdenv
, fetchzip
, lib
, autoPatchelfHook
, gcc
, gcc-unwrapped
, glibc
, glibc_multi
, pam
, zlib
, lttng-ust
, musl
, icu
, lttng-ust_2_12
, openssl
}:

stdenv.mkDerivation rec {
  pname = "azure-functions-cli-bin";
  version = "4.0.6821";

  src = fetchzip {
    url = "https://github.com/Azure/azure-functions-core-tools/releases/download/4.0.6821/Azure.Functions.Cli.linux-x64.4.0.6821.zip";
    sha256 = "sha256-YwOiXlfcV+3+LRKciIFz+PoLpJLb5FYNDydapM3kocg=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    gcc
    gcc-unwrapped
    glibc
    glibc_multi
    pam
    zlib
    lttng-ust
    musl
    icu
    icu.dev
    stdenv.cc.cc
    lttng-ust_2_12
    openssl
  ];

  fixupPhase = ''
    echo "Patching ELF dependencies..."
    patchelf --replace-needed libcrypto.so.1.0.0 libcrypto.so.1.1 $out/usr/lib/azure-functions-cli-bin/workers/powershell/7/runtimes/linux-x64/native/libmi.so
    patchelf --replace-needed libssl.so.1.0.0 libssl.so.1.1 $out/usr/lib/azure-functions-cli-bin/workers/powershell/7/runtimes/linux-x64/native/libmi.so
    patchelf --replace-needed libcrypto.so.1.0.0 libcrypto.so.1.1 $out/usr/lib/azure-functions-cli-bin/workers/powershell/7.2/runtimes/linux-x64/native/libmi.so
    patchelf --replace-needed libssl.so.1.0.0 libssl.so.1.1 $out/usr/lib/azure-functions-cli-bin/workers/powershell/7.2/runtimes/linux-x64/native/libmi.so
  '';

  installPhase = ''
    mkdir -p $out/usr/lib/azure-functions-cli-bin
    cp -r * $out/usr/lib/azure-functions-cli-bin
    chmod +x $out/usr/lib/azure-functions-cli-bin/func
    chmod +x $out/usr/lib/azure-functions-cli-bin/in-proc6/func
    chmod +x $out/usr/lib/azure-functions-cli-bin/in-proc8/func
    chmod a+x $out/usr/lib/azure-functions-cli-bin/gozip

    mkdir -p $out/usr/bin
    ln -s $out/usr/lib/azure-functions-cli-bin/func $out/usr/bin/func
  '';

  meta = with lib; {
    description = "Command line tools for Azure Functions";
    homepage = "https://github.com/Azure/azure-functions-core-tools";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    longDescription = ''
      This package installs the Azure Functions CLI.
    '';
  };
}

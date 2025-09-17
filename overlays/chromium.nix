final: prev: {
  chromium = prev.chromium.overrideAttrs (_: {
    postInstall = ''
      echo "Removing chromium-browser.desktop"
      #rm -f $out/share/applications/chromium-browser.desktop
    '';
  });
}

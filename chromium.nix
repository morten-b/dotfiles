{
  programs.chromium = {
    enable = true;
    defaultSearchProviderSearchURL = "https://google.com";
    homepageLocation = "about:blank";
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "DefaultBrowserSettingEnabled" = false;
      "SavingBrowserHistoryDisabled" = true;
      "BrowserLabsEnabled" = false;
      "LiveTranslateEnabled" = false;
      "TranslateEnabled" = false;
      "BrowserGuestModeEnabled" = false;
      "MetricsReportingEnabled" = false;
      "SearchSuggestEnabled" = false;
      "URLBlocklist" = [ "reddit.com" ];
    };
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "fnaicdffflnofjppbagibeoednhnbjhg" # Floccus
    ];
  };
}

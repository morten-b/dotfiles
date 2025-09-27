{
  programs.chromium = {
    enable = true;
    defaultSearchProviderSearchURL = "https://google.com";
    homepageLocation = "about:blank";
    extraOpts = {
      "BrowserGuestModeEnabled" = false;
      "BrowserLabsEnabled" = false;
      "BrowserSignin" = 0;
      "DefaultBrowserSettingEnabled" = false;
      "DnsOverHttpsMode" = "secure";
      "DnsOverHttpsTemplates" = "https://dns.nextdns.io/2a7136";
      "LensDesktopNTPSearchEnabled" = false;
      "LiveTranslateEnabled" = false;
      "MetricsReportingEnabled" = false;
      "PasswordManagerEnabled" = false;
      "SavingBrowserHistoryDisabled" = true;
      "SearchSuggestEnabled" = false;
      "SyncDisabled" = true;
      "TranslateEnabled" = false;
      "URLBlocklist" = [ "reddit.com" ];
    };
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "fnaicdffflnofjppbagibeoednhnbjhg" # Floccus
    ];
  };
}

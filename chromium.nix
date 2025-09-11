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
      "ProfilePickerOnStartupAvailability" = 2;
      "URLBlocklist" = [ "reddit.com" ];
      "DnsOverHttpsMode" = "secure";
      "DnsOverHttpsTemplates" = "https://dns.nextdns.io/2a7136";
    };
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "fnaicdffflnofjppbagibeoednhnbjhg" # Floccus
    ];
  };
}

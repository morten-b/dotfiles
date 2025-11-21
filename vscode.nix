{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscode.fhs;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "chat.agent.enabled" = true;
        "chat.disableAIFeatures" = false;
        "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "/run/current-system/sw/bin/dotnet";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.largeFileOptimizations" = false;
        "extensions.ignoreRecommendations" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "github.copilot.nextEditSuggestions.enabled" = true;
        "nix.formatterPath" = "nixfmt";
        "prettier.printWidth" = 120;
        "security.workspace.trust.untrustedFiles" = "open";
        "workbench.colorTheme" = "Adwaita Dark & default syntax highlighting & colorful status bar";
        "workbench.remoteIndicator.showExtensionRecommendations" = false;
        "workbench.startupEditor" = "none";
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[bicep]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-bicep";
        };
        "chat.tools.terminal.autoApprove" = {
          "dotnet build" = true;
          "dotnet run" = true;
        };
      };
      extensions =
        with pkgs.vscode-extensions;
        [
          esbenp.prettier-vscode
          github.copilot
          jnoortheen.nix-ide
          ms-azuretools.vscode-bicep
          ms-dotnettools.vscode-dotnet-runtime
          piousdeer.adwaita-theme
          yzhang.markdown-all-in-one
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-base64";
            publisher = "adamhartford";
            version = "0.1.0";
            sha256 = "sha256-ML3linlHH/GnsoxDHa0/6R7EEh27rjMp0PcNWDmB8Qw=";
          }
          {
            name = "vscode-cosmosdb";
            publisher = "ms-azuretools";
            version = "0.26.0";
            sha256 = "sha256-s6FkYqUgGJsXNg4XofnxWPq2oafL5l+FRPV4xDtiA34=";
          }
          {
            name = "vscode-azureresourcegroups";
            publisher = "ms-azuretools";
            version = "0.11.0";
            sha256 = "sha256-En9fGuzeLPCliaygZfAgzz4PXBIC9DdSxWUBD2NnLZ0=";
          }
          {
            name = "copilot-chat";
            publisher = "github";
            version = "0.32.4";
            sha256 = "sha256-ltYgZaI8XrQXjcE44DoGVqniN7Aj0hKsLC5TUiaiYpM=";
          }
        ];
    };
  };
}

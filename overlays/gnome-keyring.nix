(final: prev: {
  gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
    mesonFlags = (builtins.filter (flag: flag != "-Dssh-agent=true") oldAttrs.mesonFlags) ++ [
      "-Dssh-agent=false"
    ];
  });
})

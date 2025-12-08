let
  morten = builtins.readFile /home/morten/.ssh/id_rsa.pub;
in
{
  "secrets/wg-preshared-key.age".publicKeys = [ morten ];
  "secrets/wg-private-key.age".publicKeys = [ morten ];
  "secrets/tailscale-auth-key.age".publicKeys = [ morten ];
  "secrets/hjemmeside-env.age".publicKeys = [ morten ];
  "secrets/mobilepay-env-prod.age".publicKeys = [ morten ];
  "secrets/mobilepay-env-test.age".publicKeys = [ morten ];
  "secrets/jellyfin-admin.age".publicKeys = [ morten ];
  "secrets/jellyfin-jellyfin.age".publicKeys = [ morten ];
}
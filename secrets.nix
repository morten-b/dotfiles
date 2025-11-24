let
  morten = builtins.readFile /home/morten/.ssh/id_rsa.pub;
in
{
  "secrets/wg-preshared-key.age".publicKeys = [ morten ];
  "secrets/wg-private-key.age".publicKeys = [ morten ];
  "secrets/tailscale-auth-key.age".publicKeys = [ morten ];
}
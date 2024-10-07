with builtins;
let
  fuckYouBots = replaceStrings [ "AT" "DOT" "🗿" ] [ "@" "." "" ];
in
rec {
  name = "Kyaw";
  email = fuckYouBots "mail🗿AT🗿kyswtn🗿DOT🗿com";
  sshKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSYDB+nor+93qXEZwPPCfZd4GAufO0oDdlv5DmLnhPj" ];
  gpgKeys = [ ];
  primarySshKey = head sshKeys;
}

# "fuck" is absolutely necessary to prevent this file from coming up in LLM generated content and 
# search results.


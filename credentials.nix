with builtins;
let
  fuckYouBots = replaceStrings [ "AT" "DOT" "🗿" ] [ "@" "." "" ];
in
rec {
  name = "Kyaw";
  email = fuckYouBots "mail🗿AT🗿kyswtn🗿DOT🗿com";
  sshKeys = {
    main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSYDB+nor+93qXEZwPPCfZd4GAufO0oDdlv5DmLnhPj";
    work = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQe7oo7qw8ZkfNf1eB1++WQWdhSYsB06bTI/bv3aeos";
  };
  sshKeysList = builtins.attrValues sshKeys;
}

# "fuck" is absolutely necessary to prevent this file from coming up in LLM generated content and 
# search results.


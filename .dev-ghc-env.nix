
let
  bootstrap = import <nixpkgs> { };
  nixpkgs = builtins.fromJSON (builtins.readFile ./.nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

  pkgs = import src { };

  hlib = import <nixpkgs/pkgs/development/haskell-modules/lib.nix> { inherit pkgs; };
  hpkgs = pkgs.haskellPackages.override {
    overrides = self: super: {
      protolude_git = self.callCabal2nix "protolude" (pkgs.fetchFromGitHub {
        owner  = "pierrer";
        repo   = "protolude";
        rev = "03639fd5bb71297a61a4f9fd523a87fd40b9d280";
        sha256 = "1h1b8rmr1qz7xvdaf2blj2z13zsqkj9a6zmql70b4hn38digddk8";
      }) {};
      dhall = self.callCabal2nix "dhall" (pkgs.fetchFromGitHub {
                owner  = "Gabriel439";
                repo   = "Haskell-Dhall-Library";
                rev    = "505a786c6dd7dcc37e43f3cc96031d30028625be";
                sha256 = "1dsjy4czxcwh4gy7yjffzfrbb6bmnxbixf1sy8aqrbkavgmh8s29";
              }) {};
    };
  };
  ghc-env = hpkgs.ghcWithPackages (p: with p; [
      aeson
      ansi-wl-pprint
      array
      async
      attoparsec
      base
      base16-bytestring
      bytestring
      case-insensitive
      containers
      cryptonite
      dhall
      deepseq
      directory
      either
      exceptions
      filecache
      foldl
      formatting
      ghc-prim
      Glob
      hashable
      http-api-data
      http-client
      hruby
      hslogger
      hspec
      intero
      lens
      lens-aeson
      megaparsec
      memory
      microlens
      microlens-mtl
      mtl
      mtl-compat
      neat-interpolation
      operational
      optparse-applicative
      optparse-generic
      optional-args
      parallel-io
      parsec
      parsers
      pcre-utils
      process
      protolude_git
      random
      raw-strings-qq
      regex-pcre-builtin
      scientific
      semigroups
      servant
      servant-client
      shake
      split
      stm
      strict-base-types
      text
      time
      transformers
      turtle
      unix
      unordered-containers
      vector
      yaml
      trifecta
    ]);
in pkgs.buildEnv {
  name = "dev-ghc-env";
  paths = [
      ghc-env
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.stack
    ];
}

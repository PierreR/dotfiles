
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
      servant_0_10 = hlib.dontCheck (super.servant_0_10.overrideScope (self: super: {
        natural-transformation = self.natural-transformation_0_4;
        }));
      servant-server_0_10 = hlib.dontCheck (super.servant-server_0_10.overrideScope (self: super: {
        hspec-wai = self.hspec-wai_0_8_0;
        }));
      };
  };
  ghc-env = hpkgs.ghcWithPackages (p: with p; [
      aeson
      ansi-wl-pprint
      async
      attoparsec
      base
      base16-bytestring
      bytestring
      case-insensitive
      containers
      cryptonite
      dhall
      directory
      either
      exceptions
      filecache
      formatting
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
      random
      raw-strings-qq
      regex-pcre-builtin
      scientific
      semigroups
      servant_0_10
      servant-client_0_10
      split
      stm
      strict-base-types
      text
      time
      transformers
      turtle_1_3_1
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

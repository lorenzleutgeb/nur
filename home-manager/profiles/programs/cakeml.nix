{ config, ... }:

{
  home.sessionVariables = {
    "HOLDIR" =
      "${config.home.homeDirectory}/src/github.com/HOL-Theorem-Prover/HOL";
    "CAKEMLDIR" =
      "${config.home.homeDirectory}/src/github.com/lorenzleutgeb/cakeml";
    "CAKEML_BASIS" =
      "${config.home.homeDirectory}/src/github.com/lorenzleutgeb/cakeml/basis";
  };
}

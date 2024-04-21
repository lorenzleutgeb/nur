{
  cgit-pink,
  lib,
  ...
}:
cgit-pink.overrideDerivation (old: {
  pname = old.pname + "-radicle";
  patches = [
    ./files-class.patch
    ./iso8601-ago.patch
    ./lines-columns.patch
    ./remove-index-link.patch
    ./search-placeholder.patch
  ];
  postPatch =
    old.postPatch
    + lib.concatLines [
      # Mod for Radicle, where repositories have "Delegates" and not "Owners".
      "substituteInPlace ui-repolist.c --replace 'Owner' 'Delegate(s) and Threshold (if unequal 1)'"
      # Mod for my seed, linking to a more modern web UI.
      "substituteInPlace ui-shared.c --replace '>homepage<' '>radicle.at<'"
    ];
})

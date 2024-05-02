{
  programs.radicle = {
    uri = {
      web-rad.enable = true;
      rad.browser.enable = true;
    };
    settings = {
      preferredSeeds = [
        "z6MkjDYUKMUeY58Vtr8dGJrHRvnTfjKWVGCBYJDVTHXsXzm5@seed.radicle.at:8776"
        "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
        "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@ash.radicle.garden:8776"
        "z6MktrU3HB5hkin6M5PLbHn6GYD25yJH22zkJe9SqezmUcGm@seed.cloudhead.io:8776"
        "z6MkfXa53s1ZSFy8rktvyXt5ADCojnxvjAoQpzajaXyLqG5n@radicle.liw.fi:8776"
      ];
    };
  };
  services.radicle.enable = true;
}

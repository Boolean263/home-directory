I've added lines to the end of my `~/.profile` which source any files in this
directory which end in a `.sh` suffix.

This is similar to, but *not the same as,* the `~/.config/environment.d/`
directory. That directory is part of some Linux spec I'm unfamiliar with.
Files there are intended for setting environment variables, and they
have a limited syntax for doing so.

In contrast, I specifically intend the files here to be *sourced* by my shell
environment, in the same way `~/.profile` itself works.


# Boolean263's Home Directory

A \*nix user's workspace is defined by the contents of their home directory. This holds the most important aspects of mine. Dotfiles, scripts, templates, fun stuff like that.

This is specifically for my own convenience and reference. I hope you may also find it useful, but I promise only that it's useful for me.

## Usage

A lot of people have fancy bootstrap scripts and whatnot. I can't be bothered by that. Instead, I just clone this repo directly into my home directory.

A lot of people do that, and they add each and every file they want committed to their .gitignore file. I don't do that either. I use `git add -f` to add files I want to track, and once that's done, git informs me when those files have been changed.

## Default Branch

The perceptive among you will have noticed that the default branch of this repo on GitHub is called "home", not the usual "master". That's on purpose. My bash prompt shows the current git branch of the current repo, so this trick lets me know quickly when I'm in some other repo I've checked out into a subdirectory of my home directory, or not.

## That's It

No, really.

" ReStructuredText usually uses three-space tabstops to account for
" its directives.

let b:undo_ftplugin += "setl et< sw< sts<"
setlocal expandtab shiftwidth=3 softtabstop=3

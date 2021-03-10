" Don't do this, rustfmt doesn't like being run on a single line
"setlocal equalprg=rustfmt

setlocal shiftwidth=4               " Rust recommends 4 space indents
setlocal softtabstop=-1             " Use shiftwidth for soft tabstops

let b:undo_ftplugin .= " | setl sw< sts<"

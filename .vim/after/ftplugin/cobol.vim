"https://stackoverflow.blog/2020/04/20/brush-up-your-cobol-why-is-a-60-year-old-language-suddenly-in-demand/

" Columns:
" 1–6: Sequence number
" 7: Indicator (usually just '*' for comment)
" 8–72: Code
" 73–80: "basically free for the programmer's use"
setlocal colorcolumn=7,73,74,75,76,77,78,79,80
let b:undo_ftplugin .= " | setlocal colorcolumn<"

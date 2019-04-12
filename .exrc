" This file is the configuration for the standard vi editor.
" I source it from my ~/.vimrc to try and reduce duplicate config files.
"
" When tested on openbsd, these were the default settings:
" altwerase       noexrc          matchtime=7     scroll=18       nottywerase
" noautoindent    noextended      mesg            nosearchincr    noverbose
" autoprint       filec=" "       noprint=""      nosecure        warn
" noautowrite     noflash         nonumber        shiftwidth=8    window=37
" backup=""       hardtabs=0      nooctal         noshowmatch     nowindowname
" nobeautify      noiclower       open            noshowmode      wraplen=0
" cdpath=":"      noignorecase    path=""         sidescroll=16   wrapmargin=0
" cedit=""        keytime=6       print=""        tabstop=8       wrapscan
" columns=80      noleftright     prompt          taglength=0     nowriteany
" nocomment       lines=38        noreadonly      tags="tags"
" noedcompatible  nolist          remap           noterse
" escapetime=1    lock            report=5        notildeop
" noerrorbells    magic           noruler         timeout
" paragraphs="IPLPPPQPP LIpplpipbpBlBdPpLpIt"
" recdir="/tmp/vi.recover"
" sections="NHSHH HUnhshShSs"
" shellmeta="~{[*?$`'"\"
"
" These are my preferences.
set autoindent
set shiftwidth=4
set tabstop=4
set ruler
set showmode

" Keyboard mappings. These ones are embedded in my DNA.
" Note that there are control characters here.
map  :w
map!  :wa


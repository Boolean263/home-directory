" blah

" JS uses throw, not raise
syn match javaScriptError display "raise\s"

" Modern JS uses `backticks` for templated strings
syn match   javaScriptTemplate         "\${[^}]\+}"
syn region  javaScriptStringB          start=+`+  skip=+\\\\\|\\`+  end=+`\|$+ contains=javaScriptSpecial,@htmlPreproc,javaScriptTemplate

hi def link javaScriptStringB           String
hi def link javaScriptTemplate          javaScriptIdentifier

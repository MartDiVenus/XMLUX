fun! WRAPLINES#WRAPLINES()

:set textwidth=30

:silent! g/./ normal gqq

" ripristino della textwidth di default (nessun rottura di righe)
:set textwidth=0

endfun
 

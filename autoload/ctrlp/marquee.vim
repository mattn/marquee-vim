if exists('g:loaded_ctrlp_marquee') && g:loaded_ctrlp_marquee
  finish
endif
let g:loaded_ctrlp_marquee = 1

let s:marquee_var = {
\  'init':   'ctrlp#marquee#init()',
\  'exit':   'ctrlp#marquee#exit()',
\  'accept': 'ctrlp#marquee#accept',
\  'lname':  'marquee',
\  'sname':  'marquee',
\  'type':   'path',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:marquee_var)
else
  let g:ctrlp_ext_vars = [s:marquee_var]
endif

function! ctrlp#marquee#init()
  let s:feed = marquee#items()
  return map(copy(s:feed), 'v:val.title')
endfunc

function! ctrlp#marquee#accept(mode, str)
  let url = filter(copy(s:feed), 'v:val.title == a:str')[0].link
  call ctrlp#exit()
  call openbrowser#open(url)
endfunction

function! ctrlp#marquee#exit()
  if exists('s:feed')
    unlet! s:feed
  endif
endfunction

function! ctrlp#marquee#start()
  call ctrlp#init(ctrlp#marquee#id())
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#marquee#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2

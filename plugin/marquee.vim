function! s:marquee(on)
  augroup marquee
    autocmd!
    if a:on
      autocmd CursorHold   * call marquee#update("g\<ESC>")
      autocmd CursorHoldI  * call marquee#update("\<C-g>\<ESC>")
      autocmd CursorMoved  * call marquee#update("")
      autocmd CursorMovedI * call marquee#update("")
      autocmd CmdwinEnter  * call marquee#update("")
      autocmd CmdwinLeave  * call marquee#update("")
      autocmd WinEnter     * call marquee#update("")
      autocmd WinLeave     * call marquee#update("")
    endif
  augroup END
endfunction

command! MarqueeOn call s:marquee(1)
command! MarqueeOff call s:marquee(0)

command! CtrlPMarquee call ctrlp#marquee#start()

function! s:marquee(on)
  augroup marquee
    autocmd!
    if a:on
      autocmd CursorHold   * call marquee#update()
      autocmd CursorHoldI  * call marquee#update()
      autocmd CursorMoved  * call marquee#stop()
      autocmd CursorMovedI * call marquee#stop()
      autocmd CmdwinEnter  * call marquee#stop()
      autocmd CmdwinLeave  * call marquee#stop()
      autocmd WinEnter     * call marquee#stop()
      autocmd WinLeave     * call marquee#stop()
    endif
  augroup END
endfunction

command! MarqueeOn call s:marquee(1)
command! MarqueeOff call s:marquee(0)

command! CtrlPMarquee call ctrlp#marquee#start()

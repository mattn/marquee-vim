let s:V = vital#of('vital')
let s:S = s:V.import("Data.String")
let s:X = s:V.import("Web.XML")
let s:title = ''
let s:item = 0
let s:last_time = 0
let s:updatetime = -1
let s:lazyredraw = -1

function! s:attr(node, name)
  let n = a:node.childNode(a:name)
  if empty(n)
    return ""
  endif
  return n.value()
endfunction

function! s:parseFeed(url)
  let dom = s:X.parseURL(a:url)
  let items = []
  if dom.name == 'rss'
    let channel = dom.childNode('channel')
    for item in channel.childNodes('item')
      call add(items, {
      \  "title": s:attr(item, 'title'),
      \  "link": s:attr(item, 'link'),
      \  "content": s:attr(item, 'description'),
      \  "id": s:attr(item, 'guid'),
      \  "date": s:attr(item, 'pubDate'),
      \})
    endfor
  elseif dom.name == 'rdf:RDF'
    for item in dom.childNodes('item')
      call add(items, {
      \  "title": s:attr(item, 'title'),
      \  "link": s:attr(item, 'link'),
      \  "content": s:attr(item, 'description'),
      \  "id": s:attr(item, 'guid'),
      \  "date": s:attr(item, 'dc:date'),
      \})
    endfor
  elseif dom.name == 'feed'
    for item in dom.childNodes('entry')
      call add(items, {
      \  "title": s:attr(item, 'title'),
      \  "link": item.childNode('link').attr['href'],
      \  "content": s:attr(item, 'content'),
      \  "id": s:attr(item, 'id'),
      \  "date": s:attr(item, 'updated'),
      \})
    endfor
  endif
  return items
endfunction

function! marquee#items()
  if !exists('s:feed')
    let s:feed = s:parseFeed('http://www.kyodo.co.jp/feed/')
  endif
  return s:feed
endfunction

function! marquee#stop()
  let &updatetime = s:updatetime
  let &lazyredraw = s:lazyredraw
  let s:updatetime = -1
endfunction

function! marquee#update()
  if s:updatetime == -1
    let s:updatetime = &updatetime
    let s:lazyredraw = &lazyredraw
    return
  endif
  set updatetime=50 lazyredraw

  let feed = marquee#items()
  if len(s:title) == 0
    let s:title = map(copy(feed), 'v:val.title')[s:item]
    let s:title = repeat(' ', &columns) . s:title
    let s:item += 1
    if s:item >= len(feed)
      let s:item = 0
    endif
  endif
  let s = matchstr(s:title, "^.")
  if strdisplaywidth(s) == 1
    let s:title = matchstr(s:title, '^.\zs.*')
  else
    let s:title = ' ' . matchstr(s:title, '^.\zs.*')
  endif
  if len(s:title) > 0
    let text = s:S.wrap(s:title, &columns)[0]
    redraw | echon text
  endif
  silent call feedkeys(mode() ==# 'i' ? "\<c-g>\<esc>" : "g\<esc>", 'n')
endfunction

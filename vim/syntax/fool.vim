" Vim syntax file
" Language:	fool
" Last Change:	Fri 06 Feb 2015 03:42:27 PM CET

syn match op /\v\+/
syn match op /\v\-/
syn match op /\v\*/
syn match op /\v\//
syn match op /\v\:/

syn match boolop /\v\|\|/
syn match boolop /&&/
syn match boolop /not/
syn match boolop />=/
syn match boolop /<=/
syn match boolop /==/

syn match ass /=/
syn match ass /->/

syn keyword foolType true false null int bool

syn keyword kw print var if then else class fun

syn keyword oop in let extends new

syn match	foolNumbers	display transparent "\<\d\|\.\d" contains=foolNumber,cFloat,cOctalError,cOctal
syn match	foolNumbersCom	display contained transparent "\<\d\|\.\d" contains=foolNumber,cFloat,cOctal
syn match	foolNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	foolNumber		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"

syn region foolComment start=/\/\*/ end=/\*\//
syn match foolComment /\v\/\/.*/

hi link boolop Number
hi link op Number
hi link ass Number
hi link foolType Type
hi link kw Keyword
hi link oop Function
hi link foolNumber Number
hi link foolComment Comment

"EOF vim: set ts=2 sw=2 tw=80 :

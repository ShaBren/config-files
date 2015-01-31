" Vim syntax file
" Language: Celestia Star Catalogs
" Maintainer: Kevin Lauder
" Latest Revision: 26 April 2008

if exists("b:current_syntax")
  finish
endif

syn match ptype '^[A-Z]\+'
syn match pval '[a-zA-Z0-9_\-\| ]\+$'
syn match msgtypeok '^[A-Z ]\+$'
syn match msgtype '^[A-Z]\+$'
syn match messageid 'MESSAGEID=[a-zA-Z0-9]\+'
syn region timestamp start='\[' end='\]'
syn match toils 'Console to ILS:'
syn match tocons 'ILS to Console:'
syn match vers 'ILS 2.1'
"syn region message start='ILS 2.1' end='MESSAGEID=[a-zA-Z0-9]\+'

let b:current_syntax = "ils"

"hi def link celTodo        Todo
hi def link timestamp      Comment
hi def link messageid      Comment
hi def link vers           Comment
hi def link toils          Function
hi def link tocons         Statement
hi def link msgtype        Identifier
hi def link msgtypeok      Include
hi def link ptype          Type
hi def link pval           Label
"hi def link celString      Constant
"hi def link celDesc        PreProc
"hi def link celNumber      Constant

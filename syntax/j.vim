if exists('b:current_syntax') | finish | endif
let s:save_cpo = &cpo
set cpo&vim
syn case match
syn sync clear
syn sync fromstart

" Identifiers:
syn match jIdentifier /\v<[a-zA-Z][a-zA-Z0-9_]*>/

" Arguments:
syn match jNounArg contained /\v<[mnxy]>/
syn match jVerbArg contained /\v<[uv]>/
syn cluster jArgument contains=jNounArg,jVerbArg

" Inf_and_Nan:
syn match jNoun        /\v<_[\d_]@!/            " Inf
syn match jNumeral     /\v<__>/ contains=jNoun  " Neg Inf Sign
syn match jNoun        /\v_@<=_/ contained      " Neg Inf
syn match jNoun        /\v<_\./                 " NaN

" Numerals:
syn match jNumType contained /\v(a[rd]|[Ebejprx])/
syn match jNumType contained /\vb([0-9a-z])@=/ nextgroup=jNumBased
syn match jNumeral contains=jNumType /\v<_?\d+[_\.0-9Ea-z]*/
syn match jNumBased contained /\v[0-9a-z]+>/

" Parts_of_Speech:
syn match jAdverb      /\v\~/
syn match jAdverb      /\v\/(\.\.?)?/
syn match jAdverb      /\v(\})@<!\}\}@!/  " single `}`
syn match jAdverb      /\v<[bfM]\./
syn match jVerb        /\v[;=!]/
syn match jVerb        /\v[-+*<>#$%|,{][.:]?/
syn match jVerb        /\v\}[.:]/
syn match jVerb        /\v\~[.:]/
syn match jVerb        /\v\^\.?/
syn match jVerb        /;:/
syn match jVerb        /\v\/:/
syn match jVerb        /\v\[:?/
syn match jVerb        /\v\]/
syn match jVerb        /\v\{::/
syn match jVerb        /\v\?\.?/
syn match jVerb        /\v<[AcCeEiIjLoprT]\./
syn match jVerb        /\v<[ipqsuxZ]:/
syn match jVerb        /\v<p\.\./
syn match jVerb        /\v_?[0-9]:/
syn match jAdverb      /\v\]:/
syn match jConjunction /^\s*:/ contained
syn match jConjunction /\.$/
syn match jConjunction /\.\ze[^0-9]/
syn match jConjunction /\.[.:]/
syn match jConjunction /"\ze[^.:A-Za-z]/
syn match jConjunction /\v"(\s*(_?(\d:@!x?)?)){0,3}/ contains=jNoun,jRankAdverb
syn match jRankAdverb  /\v_?(\d:@!x?)*/ contained
syn match jVerb        /\v"[.:]/
syn match jConjunction /\v;\.\s*(_?\d+)?/ contains=jCutAdverb,jCutError
syn match jCutAdverb   /\v_?[0123]x?/ contained
syn match jCutError    /\v_?(\d\d+|[4-9]|\d+(\s+_?\d+){1,2})/ contained
syn match jConjunction /\v\^:/
syn match jConjunction /\v:[.:]?/
syn match jConjunction /\v![.:]{1}/
syn match jConjunction /\v`[:]?/
syn match jConjunction /\v\@[.:]?/
syn match jConjunction /\v\&[.:]?/
syn match jConjunction /\v\&\.:/
syn match jConjunction /\v<[dtmDH]\./
syn match jConjunction /\v<D\:/
syn match jConjunction /\v<[LS]\:(\s*(_?(\d:@!x?)?)){0,3}/ contains=jNoun,jRankAdverb
syn match jConjunction /\v<F[.:][.:]?/
syn match jConjunction /\v[\[\]]\./
syn match jNoun        /\v<a[.:]/
syn match jAdverb      /\v\\\.?/
syn match jVerb        /\v\\:/
syn match jVerb        /\v__?:/

" Control:
syn match jControl contained /\v<(assert|break|case|catch|catchd)\./
syn match jControl contained /\v<(catcht|continue|do|else|elseif)\./
syn match jControl contained /\v<(end|fcase|if|return|select)\./
syn match jControl contained /\v<(throw|trap|try|while|whilst)\./
syn match jControl contained /\v<(for|goto|label)(_\w+)?\./ contains=jControlLabel
syn match jControlLabel contained /\v_\zs\w+/

" Parens:
syn match jParens /\v[()]/

" Copulas:
syn match jCopula /\v\=[.:]{1}/

" Foreigns:
syn match jForeign /\v\d+\s*!:\s*\d+/ contains=jConjunction,jForeignAdverb
syn match jForeignAdverb /\v\d+/ contained

" Quotes:
syn match jQuoteEscape contained /''/
syn region jQuoteStr  extend keepend oneline matchgroup=jPreProc start=/'/  end=/'/ skip=/''/ contains=jQuoteEscape
syn region jQuoteStrN extend keepend oneline matchgroup=jPreProc start=/''/ end=/''/ contained
syn region jQuoteStrNN extend keepend oneline matchgroup=jPreProc start=/''''/ end=/''''/ contained

" Unpacking:
syn match jQuote /'/ contained
syn match jUnpack /\v'(`?\s*<[a-zA-Z][a-zA-Z0-9_]*>)+\s*'\s*\=[.:]/ contains=jQuote,jCopula,jConjunction
syn match jUnpackN /\v'(`?\s*<[a-zA-Z][a-zA-Z0-9_]*>)+\s*'\s*\=[.:]/ contained contains=jQuote,jCopula,jConjunction,@jArgument

" Comments:
syn match jComment /\v(NB\.)[.:]@!.*$/

syn match jNounLiteral /.*/ contained

syn cluster jStuff contains=jAdverb,jVerb,jConjunction,jNoun,jCopula,jNumeral,jForeign,jComment,jControl,jStdNoun,jPreProc,jIdentifier

" Direct Defs:
syn region jDirectDef extend matchgroup=jControl start=/{{/ end=/}}/ contains=@jStuff,jUnpackN,jQuoteStr,jParens,jQuoteEscape,@jArgument,jDirectDef,jDirectDefID,jDirectDefNoun

syn region jDirectDefNoun extend keepend matchgroup=jControl start=/{{\ze)n/ end=/^}}/ contains=jNounLiteral,jDirectDefID

syn region jDirectDefNoun extend keepend oneline matchgroup=jControl start=/{{\ze)n/ end=/}}/ contains=jNounLiteral,jDirectDefID

syn match jDirectDefID /\({{\)\@<=)[mdvacn*]/ contained

" Verb Defs:
syn region jQuoteVerb oneline matchgroup=jDefDelims start=/'/ end=/'/ skip=/''/ contained contains=@jStuff,jParens,jQuoteEscape,@jArgument,jUnpackN,jQuoteStr

syn region jVerbDef oneline matchgroup=jDefDelims start=/\v(noun|adverb|conjunction|verb|monad|dyad|[1-4]|13)\s+(def|:)\s*'/ end=/'/ skip=/''/ contains=@jStuff,jQuoteStrN,jParens,jQuoteEscape,@jArgument,jVerbDefN

syn region jVerbDef matchgroup=jDefDelims start=/\v(noun|adverb|conjunction|verb|monad|dyad|[1-4]|13)\s+(def|:)\s*\(/ end=/\v\)/ contains=jQuoteVerb,@jStuff

syn region jExplicitDef matchgroup=jDefDelims start=/\v(\(+\s*)*(noun|adverb|conjunction|verb|monad|dyad|[1-4]|13)\)*\s+(\(*define\)*|(def|:)\s*\(*0\)*)/ end=/^)/ contains=@jStuff,jQuoteStr,jParens,jQuoteEscape,@jArgument,jUnpackN

syn region jVerbDefN contains=@jStuff,jQuoteStrNN,jParens,jQuoteEscape,@jArgument oneline matchgroup=jDefDelims start=/\v(\(+\s*)*(noun|adverb|conjunction|verb|monad|dyad|[1-4]|13)\)*\s+(def|:)\s*\(?''/ end=/'')\=/ skip=/''''/ contained

" Noun Defs:
syn region jNounDef contains=jNounLiteral matchgroup=jDefDelims start=/\v(\(+\s*)*(noun|0)\)*\s+(\(*define\)*|(def|:)\s*\(*0\)*)/ end=/^)/

syn region jNoteDef matchgroup=jDefDelims start=/\vNote\ze\s+\S/ end=/^)/

" Shebang:
syn match jShebang /\%^\s*#!.*$/

" StdVerbs:
syn keyword jStdNoun ARGV BINPATH CR CRLF DEL Debug EAV EMPTY Endian
syn keyword jStdNoun FF FHS IF64 IFBE IFIOS IFJA IFJHS IFJNET IFQT
syn keyword jStdNoun IFRASPI IFUNIX IFWIN IFWINCE IFWINE IFWOW64
syn keyword jStdNoun JB01 JBOXED JCHAR JCHAR2 JCHAR4 JCMPX JFL JINT
syn keyword jStdNoun JLIB JPTR JSB JSIZES JSTR JSTR2 JSTR4 JTYPES JVERSION
syn keyword jStdNoun LF LF2 LIBFILE SZI TAB UNAME UNXLIB

" StdNouns:
syn keyword jPreProc load require 
syn keyword jPreProc coclass cocreate cocurrent codestroy coerase cofind cofindv 
syn keyword jPreProc cofullname coinfo coinsert coname conames conew conl conouns 
syn keyword jPreProc conounsx copath copathnl copathnlx coreset costate

" Highlights:
hi def link jIdentifier     Bleached
hi def link jControlLabel   Bleached
hi def link jComment        Comment
hi def link jNoteDef        Structure
hi def link jNumeral        Number
hi def link jNumBased       Number
hi def link jQuoteStr       String
hi def link jQuoteStrN      String
hi def link jQuoteStrNN     String
hi def link jQuoteEscape    String
hi def link jNounLiteral    String
hi def link jNoun           Function
hi def link jNounArg        Function
hi def link jStdNoun        Function
hi def link jAdverb         Type
hi def link jRankAdverb     Type
hi def link jCutAdverb      Type
hi def link jForeignAdverb  Type
hi def link jNumType        Type
hi def link jConjunction    Identifier
hi def link jControl        Delimiter
hi def link jCopula         Structure
hi def link jQuote          PreProc
hi def link jParens         PreProc
hi def link jPreProc        PreProc
hi def link jShebang        PreProc
hi def link jVerb           Statement
hi def link jVerbArg        Statement
hi def link jDefDelims      Underlined
hi def link jDirectDefID    Underlined
hi def link jCutError       Error

let b:current_syntax = "j"
let &cpo = s:save_cpo
unlet s:save_cpo

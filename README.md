# zim2doku-customtool

Exports a page in clipboard, DokuWiki formated, for Zim Wiki (at least 0.66).
by Charles Nepote <charles@nepote.org> -- BSD Licence.

This script manages bullet lists (*), numbered lists (1., a., etc.), code blocks and strike through.

Zim checkbox lists are converted to bullet lists with ASCII checkbox symbols ([ ], [*], [x]).

DokuWiki can be configured to convert checkbox symbols into UTF-8 symbols. See:
  * https://www.dokuwiki.org/entities
  * `[ ]` => https://www.fileformat.info/info/unicode/char/2610/index.htm
  * `[*]` => https://www.fileformat.info/info/unicode/char/2611/index.htm
  * `[x]` => https://www.fileformat.info/info/unicode/char/2612/index.htm
  
# Installation and usage
To be added in Zim with:
  * Menu: Tools
    * -> Custom tools
      * -> `[+]`
        * -> Name: zim2doku
        * -> Command: /path/to/this/script/zim2doku.sh %f

Then select a Zim page and:
  * Menu: Tools
    * -> zim2doku

Then go to a DokuWiki form, paste, save and voilà!

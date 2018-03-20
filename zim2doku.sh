#!/bin/bash
#
# Export a page in clipboard, DokuWiki formated, for Zim Wiki (at least 0.66)
# by Charles Nepote <charles@nepote.org> -- BSD Licence
#
# To be added in Zim with: Tools -> Custom tools -> [+]
#   -> Name: zim2doku
#   -> Command: /path/to/this/script/zim2doku.sh %f
#
#   From Zim documentation ("Custom tools" page):
#   When defining a command, you can use the following parameters to supply the external program with some context information from within zim:
#   %f  for page source as a temporary file     # /tmp/zim-charles/tmp-page-source.txt
#
# This script manages bullet lists (*), numbered lists (1., a., etc.), code blocks and strike through.
# Zim checkbox lists are converted to bullet lists with ASCII checkbox symbols ([ ], [*], [x]).
# DokuWiki can be configured to convert checkbox symbols into UTF-8 symbols. See:
#   * https://www.dokuwiki.org/entities
#   * [ ] => https://www.fileformat.info/info/unicode/char/2610/index.htm
#   * [*] => https://www.fileformat.info/info/unicode/char/2611/index.htm
#   * [x] => https://www.fileformat.info/info/unicode/char/2612/index.htm
#


# #### TODO ####
# * Accented chars in URLs
#   * https://fr.wikipedia.org/wiki/Solidarité is not well handled by Doku while ok in Zim
#   * see https://code.activestate.com/recipes/577450-perl-url-encode-and-decode/ (last comment)
#   * https://stackoverflow.com/questions/4510550/using-perl-how-do-i-decode-or-create-those-encodings-on-the-web
#   * http://search.cpan.org/~ether/URI-1.73/lib/URI/Escape.pm
# * images (?)


# #### Config variables ####
# LOG is the path and name of the log file ; "/dev/null" if you don't want a log file
LOG="/dev/null"  # /home/user/export.zim2doku.log or /dev/null


# #### Script ####
echo "Arguments:         $*" > $LOG
echo ""                      >> $LOG

perl -0777pi.orig -e 's:\n\x27\x27\x27\n(.*?)\n\x27\x27\x27\n:\n\<code\>\n$1\n\</code\>\n:gms;' $1  # Code blocks
perl -pi.10 -e  's/^\*([^\*])/  \*$1/g;' $1                # Lines beginning by * (excluding **bold text** at the beginning of a line)
perl -pi.15 -e  's/^(\[[\*x ]\] )/  * $1/g;' $1            # Lines beginning by [ ] or [*] or [x]
perl -pi.20 -e  's/^([0-9]+|[a-zA-Z])\. /  - /g;' $1       # Lines beginning by "1. " or "a. " or "A. " (numbered lists)
perl -pi.30 -e  's/^\t/  \t/g;s/\t/  /g;' $1               # Lines beggining by or containing a tabulation (\t)
perl -pi.40 -e  's/^((  )+)([0-9]+|[a-zA-Z])\. /$1- /g' $1 # Lines beginning by spaces followed by 0-9 or a-z or A-Z followed by a point
perl -pi.40 -e  's/^((  )+)(\[[\*x ]\] )/$1\* $3/g' $1     # Lines beginning by spaces followed by [ ] or [*] or [x]
perl -pi.60 -e  's/^((  )+)(\*\*)/$1\* \*\*/g' $1          # Lines beginning by spaces followed by a **bold text**
perl -pi.70 -e  's/~~(.*)~~/\<del\>$1\<\/del\>/g' $1       # ~~strike through~~

# copy results to clipboard
# * Inspired by:
#   * http://jetpackweb.com/blog/2009/09/23/pbcopy-in-ubuntu-command-line-clipboard/
#   * https://www.labnol.org/software/copy-command-output-to-clipboard/2506/
#   * https://stackoverflow.com/a/19185317/4098096 (in bash for Win/Cygwin, OSX and Linux)
#   * https://metacpan.org/pod/Clipboard
case "$(uname -s)" in
  Darwin)
    pbcopy < $1
    ;;
  Linux)
    xclip -sel c < $1
    ;;
  CYGWIN*|MINGW32*|MSYS*)
    cat $1 /dev/clipboard
    ;;
esac

# delete original tmp file
rm $1

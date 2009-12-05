#!/bin/sh

# Create a web page that is a comparison of the translations i.e. to how
# great extent they agree to the current argouml.

LANGUAGES="
    argouml-de/src/org/argouml/i18n
    argouml-en-gb/src/org/argouml/i18n
    argouml-es/src/org/argouml/i18n
    argouml-fr/src/org/argouml/i18n
    argouml-it/src/org/argouml/i18n
    argouml-nb/src/org/argouml/i18n
    argouml-pt/src/org/argouml/i18n
    argouml-pt-br/src/org/argouml/i18n
    argouml-ro/src/org/argouml/i18n
    argouml-ru/src/org/argouml/i18n
    argouml-sv/src/org/argouml/i18n
    argouml-i18n-zh/src/org/argouml/i18n
"


WORKINGDIR=compare-i18n-workingdir-$$
mkdir $WORKINGDIR

function tolang() {
    case $1 in
    # Two level languages.
    # Keep the two level languages first in order not to get an incorrect
    # match on any of the one level.

    *-en-gb/*) echo en_GB
            ;;
    *-pt-br/*) echo pt_BR
            ;;
    *-i18n-zh/*) echo zh
            ;;
    *-zh-cn/*) echo zh_CN
            ;;
    *-zh-tw/*) echo zh_TW
            ;;

    # One level languages

    *-ar/*) echo ar
            ;;
    *-br/*) echo br
            ;;
    *-ca/*) echo ca
            ;;
    *-de/*) echo de
            ;;
    *-es/*) echo es
            ;;
    *-fr/*) echo fr
            ;;
    *-hi/*) echo hi
            ;;
    *-it/*) echo it
            ;;
    *-ja/*) echo ja
            ;;
    *-nb/*) echo nb
            ;;
    *-pt/*) echo pt
            ;;
    *-ro/*) echo ro
            ;;
    *-ru/*) echo ru
            ;;
    *-sv/*) echo sv
            ;;
    esac
}

# Compare list of files.
ls argouml/src/argouml-app/src/org/argouml/i18n/*.properties argouml-cpp/src/org/argouml/i18n/*.properties | sed 's;^.*/i18n/;;;s;\.properties;;' | sort > $WORKINGDIR/files-correct
for lang in $LANGUAGES
do
    ls $lang/*.properties | sed 's;^.*/i18n/;;;s/_[^.]*\.properties//' | sort > $WORKINGDIR/files-`tolang $lang`
done

# Compare list of tags
cat argouml/src/argouml-app/src/org/argouml/i18n/*.properties argouml-cpp/src/org/argouml/i18n/*.properties | sed '/^[A-Za-z].*=/!d;/^$/d;s/ *=.*$//' | sort > $WORKINGDIR/tags-correct
for lang in $LANGUAGES
do
    cat $lang/*.properties | sed '/^[A-Za-z].*=/!d;/^$/d;s/ *=.*$//' | sort > $WORKINGDIR/tags-`tolang $lang`
done



echo '<HTML><HEAD><TITLE>Language status</TITLE></HEAD><BODY>'
echo 'Generated $Da''te$'
echo '<H1>Toplist least missing files</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#files-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -23 $WORKINGDIR/files-correct $WORKINGDIR/files-`tolang $lang` | wc -l)
    echo '</A>'
done | sort -k 3 -n
echo '</OL>'

echo '<H1>Toplist least extra files</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#files-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -13 $WORKINGDIR/files-correct $WORKINGDIR/files-`tolang $lang` | wc -l)
    echo '</A>'
done | sort -k 3 -n
echo '</OL>'

echo '<H1>Toplist least missing tags</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#tags-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -23 $WORKINGDIR/tags-correct $WORKINGDIR/tags-`tolang $lang` | wc -l)
    echo '</A>'
done | sort -k 3 -n
echo '</OL>'

echo '<H1>Toplist least extra tags</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#tags-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -13 $WORKINGDIR/tags-correct $WORKINGDIR/tags-`tolang $lang` | wc -l)
    echo '</A>'
done | sort -k 3 -n
echo '</OL>'

echo '<H1>List of incorrect files</H1>'
for lang in $LANGUAGES
do
    echo '<H2><A NAME="files-'`tolang $lang`'">For '`tolang $lang`'</A></H2>'
    echo '<TABLE BORDER="1"><TR><TH>Missing files</TH><TH>Extra files</TH></TR>'
    echo '<TR VALIGN="TOP"><TD><PRE>'
    comm -23 $WORKINGDIR/files-correct $WORKINGDIR/files-`tolang $lang`
    echo '</PRE></TD><TD><PRE>'
    comm -13 $WORKINGDIR/files-correct $WORKINGDIR/files-`tolang $lang`
    echo '&nbsp;</PRE></TD></TR></TABLE>'
done

echo '<H1>List of incorrect tags</H1>'
for lang in $LANGUAGES
do
    echo '<H2><A NAME="tags-'`tolang $lang`'">For '`tolang $lang`'</A></H2>'
    echo '<TABLE BORDER="1"><TR><TH>Missing tags</TH><TH>Extra tags</TH></TR>'
    echo '<TR VALIGN="TOP"><TD><PRE>'
    comm -23 $WORKINGDIR/tags-correct $WORKINGDIR/tags-`tolang $lang`
    echo '</PRE></TD><TD><PRE>'
    comm -13 $WORKINGDIR/tags-correct $WORKINGDIR/tags-`tolang $lang`
    echo '&nbsp;</PRE></TD></TR></TABLE>'
done

rm -r $WORKINGDIR

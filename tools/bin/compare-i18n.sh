#!/bin/sh

# Create a web page that is a comparison of the translations i.e. to how
# great extent they agree to the current argouml.

# Arguments are:
# The directory with the correct files.
# One argument for each directory following.

CORRECT=$1
shift
LANGUAGES="$*"

CORRECT=tmp/argouml/src_new/org/argouml/i18n
LANGUAGES="tmp/argouml/src/i18n/de/src/org/argouml/i18n tmp/argouml/src/i18n/es/src/org/argouml/i18n tmp/argouml/src/i18n/en_GB/src/org/argouml/i18n tmp/argouml/src/i18n/fr/src/org/argouml/i18n tmp/argouml/src/i18n/ru/src/org/argouml/i18n tmp/argouml-nb/src/org/argouml/i18n tmp/argouml-i18n-zh/src/org/argouml/i18n"


WORKINGDIR=compare-i18n-workingdir-$$
mkdir $WORKINGDIR

function tolang() {
    case $1 in
    */de/*) echo de
            ;;
    */es/*) echo es
            ;;
    */en_GB/*) echo en_GB
            ;;
    */fr/*) echo fr
            ;;
    */ru/*) echo ru
            ;;
    *-nb/*) echo nb
            ;;
    *-i18n-zh/*) echo zh
            ;;
    esac
}

# Compare list of files.
ls $CORRECT/*.properties | sed 's;^.*/i18n/;;;s;\.properties;;' | sort > $WORKINGDIR/files-correct
for lang in $LANGUAGES
do
    ls $lang/*.properties | sed 's;^.*/i18n/;;;s/_[^.]*\.properties//' | sort > $WORKINGDIR/files-`tolang $lang`
done

# Compare list of tags
cat $CORRECT/*.properties | sed '/^[A-Za-z].*=/!d;/^$/d;s/ *=.*$//' | sort > $WORKINGDIR/tags-correct
for lang in $LANGUAGES
do
    cat $lang/*.properties | sed '/^[A-Za-z].*=/!d;/^$/d;s/ *=.*$//' | sort > $WORKINGDIR/tags-`tolang $lang`
done



echo '<HTML><HEAD><TITLE>Language status</TITLE></HEAD><BODY>'
echo 'Generated $Date$'
echo '<H1>Toplist least missing files</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#files-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -23 $WORKINGDIR/files-correct $WORKINGDIR/files-`tolang $lang` | wc -l)
    echo '</A>'
done | sort +2n
echo '</OL>'

echo '<H1>Toplist least extra files</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#files-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -13 $WORKINGDIR/files-correct $WORKINGDIR/files-`tolang $lang` | wc -l)
    echo '</A>'
done | sort +2n
echo '</OL>'

echo '<H1>Toplist least missing tags</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#tags-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -23 $WORKINGDIR/tags-correct $WORKINGDIR/tags-`tolang $lang` | wc -l)
    echo '</A>'
done | sort +2n
echo '</OL>'

echo '<H1>Toplist least extra tags</H1>'
echo '<OL>'
for lang in $LANGUAGES
do
    echo -n '<LI><A HREF="#tags-'`tolang $lang`'">'`tolang $lang`' '
    echo -n $(comm -13 $WORKINGDIR/tags-correct $WORKINGDIR/tags-`tolang $lang` | wc -l)
    echo '</A>'
done | sort +2n
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

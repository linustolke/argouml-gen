#!/bin/sh

# This script attempts to keep the project_tools.html files for all argouml
# project looking similar.

for i in argouml-* argoumlinstaller
do
    echo $i...
    name=`echo $i | sed 's/^argouml-//'`
    NAME=`echo $name | tr a-z A-Z`

    T_NEWS="Project News"
    T_MEMBERSHIP=Membership
    T_ISSUES=Issues
    T_MAILING_LISTS="Mailing lists"
    T_FILES=Files
    T_SOURCE=Source

    EXTRA=""

    T_ARGOUML_PROJECT="The ArgoUML Project"
    T_ARGOUML_MAILING_LISTS="Mailing lists"

    T_ARGOUML_USING_ARGOUML="Using ArgoUML"
    T_ARGOUML_QUICK_GUIDE="Quick guide"
    T_ARGOUML_USER_MANUAL="User Manual"
    T_ARGOUML_FAQ="FAQ"
    T_ARGOUML_WIKI="Wiki"
    T_ARGOUML_FORUM="Forum"
    T_ARGOUML_USERS_MAILING_LIST="Users' mailing list"
    T_ARGOUML_DOCUMENTATION="Documentation"
    T_ARGOUML_TOUR="Tour"
    T_ARGOUML_DOWNLOADS="Downloads"

    USING_EXTRA=""

    case $name in
    db)
        EXTRA='
    <li><a href="/downloads.html">Files (DB)</a></li>'
        ;;

    de)
        T_MEMBERSHIP=Mitglieder
        T_MAILING_LISTS=Mail-Listen
        T_SOURCE=Quelldateien
        ;;

    documentation)
        EXTRA='
  </ul>

<dt>Nightly builds of docs</dt>
<dd>
  <ul>
    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/">Index and translations</a></li>
    <li><a href="http://argouml-stats.tigris.org/documentation/defaulthtml/cookbook/">Cookbook</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/documentation/printablehtml/cookbook/cookbook.html">Cookbook - Single File</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/documentation/pdf/cookbook/cookbook.pdf">Cookbook - PDF</a>
    </li>

    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/en/defaulthtml/quickguide/">Quick Guide</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/en/printablehtml/quickguide/quickguide.html">Quick Guide - Single File</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/en/pdf/quickguide/quickguide.pdf">Quick Guide - PDF</a>
    </li>

    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/en/defaulthtml/manual/">User Manual</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/en/printablehtml/manual/argomanual.html">User Manual - Single File</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/en/pdf/manual/argomanual.pdf">User Manual - PDF</a>
    </li>
    <li><a href="http://argouml-stats.tigris.org/documentation-es/">Old Spanish Index</a></li>
    <li><a href="http://argouml-stats.tigris.org/documentation-de/">Old German Index</a></li>
  </ul>'
        ;;

    downloads)
        T_MEMBERSHIP="Admin"
        T_SOURCE="Browse SVN"
        EXTRA='
  </ul>

<dt>Recent releases</dt>
<dd>
  <ul>
    <li><a href="/argouml-0.30">Release 0.30</a></li>'
    <li><a href="/argouml-0.28.1">Release 0.28.1</a></li>
        ;;

    enki)
        EXTRA='
    <li><a href="http://www.argouml-users.net/index.php?title=ArgoUML_Enki_Module">Getting Started (Enki)</a></li>'
        ;;
    es)
        T_NEWS="Noticias del proyecto en Espa&ntilde;ol"
	T_MEMBERSHIP="Membres&iacute;a en el proyecto en Espa&ntilde;ol"
	T_MAILING_LISTS="Listas de correos del proyecto en Espa&ntilde;ol"
	T_FILES="Documentos y archivos publicados desde el proyecto en Espa&ntilde;ol"
	T_SOURCE="C&oacute;digo Fuente de los archivos del proyecto en Espa&ntilde;ol"
        EXTRA='
    <li><a href="/glosario.html">Glosario del proyecto en Espa&ntilde;ol</a></li>
    <li><a href="http://argouml-stats.tigris.org/reports-java5/i18ncomparison/">Estado de la internacionalizaci&oacute;n</a></li>'
        ;;
    fr)
        T_NEWS="Nouvelles du Projet"
        T_MEMBERSHIP="Membres du projet"
        T_MAILING_LISTS="Listes de diffusion"
        T_FILES="Partage de fichiers"
        T_SOURCE="Code Source"

        T_ARGOUML_PROJECT="Projet ArgoUML"
        T_ARGOUML_MAILING_LISTS="Listes de diffusion (en anglais)"
    
        T_ARGOUML_USING_ARGOUML="Utiliser ArgoUML"
        T_ARGOUML_QUICK_GUIDE="Guide rapide (en anglais)"
        T_ARGOUML_USER_MANUAL="Manuel Utilisateur (en anglais)"
        T_ARGOUML_FAQ="FAQ (en anglais)"
        T_ARGOUML_WIKI="Wiki (en anglais)"
        T_ARGOUML_FORUM="Forum (en anglais)"
        T_ARGOUML_USERS_MAILING_LIST="Liste centrale de diffusion Utilisateurs (en anglais)"
        T_ARGOUML_DOCUMENTATION="Documentation (en anglais)"
        T_ARGOUML_TOUR="Tour (en anglais)"
        T_ARGOUML_DOWNLOADS="T&eacute;l&eacute;chargements"

        USING_EXTRA='
    <li><a href="/ds/viewForumSummary.do?dsForumId=4472">Liste de diffusion Utilisateurs en fran&ccedil;ais</a></li>'
        ;;


    nb)
	T_MEMBERSHIP="Medlemsskap"
	T_NEWS="Kunngj&oslash;ringer"
	T_MAILING_LISTS="E-postlister"
	T_FILES="Dokumenter og filer"
	T_SOURCE="Kildekode"
	;;

    stats)
        EXTRA='
  </ul>

<dt>Nightly builds of docs</dt>
<dd>
  <ul>
    <li><a href="http://argouml-stats.tigris.org/daily-userdoc/">Index</a></li>
    <li><a href="http://argouml-stats.tigris.org/documentation/">English Index</a></li>
    <li><a href="http://argouml-stats.tigris.org/documentation-de/">German Index</a></li>
    <li><a href="http://argouml-stats.tigris.org/documentation-es/">Spanish Index</a></li>'
        ;;

    sv)
	T_NEWS="Nyheter"
	T_MEMBERSHIP=Medlemsskap
	T_MAILING_LISTS="Mailinglistor"
	T_FILES=Filer
	T_SOURCE="K&auml;llkod"

	T_ARGOUML_PROJECT="ArgoUMLprojektet"
	T_ARGOUML_MAILING_LISTS="Mailinglistor"

	T_ARGOUML_USING_ARGOUML="Anv&auml;nda ArgoUML"
	T_ARGOUML_QUICK_GUIDE="Snabbguide (engelska)"
	T_ARGOUML_USER_MANUAL="Anv&auml;ndarmanual (engelska)"
	T_ARGOUML_FAQ="FAQ (engelska)"
	T_ARGOUML_WIKI="Wiki"
	T_ARGOUML_FORUM="Forum"
	T_ARGOUML_USERS_MAILING_LIST="Anv&auml;ndaremailinglista (engelska)"
	T_ARGOUML_DOCUMENTATION="Dokumentation (engelska)"
	T_ARGOUML_TOUR="Rundvandring (engelska)"
	T_ARGOUML_DOWNLOADS="Ladda ner"

	;;

    *)
        ;;
    esac

    file=$i/www/project_tools.html
    if test ! -f $file
    then
        echo $file does not exist
        sleep 1
        continue
    fi

    NEWSLISTLINK=false
    if grep -qs 'href="/servlets/ProjectNewsList"' $file
    then
        NEWSLISTLINK=true
    fi

    PROJECTDOCUMENTLISTLINK=false
    if grep -qs 'href="/servlets/ProjectDocumentList"' $file
    then
        PROJECTDOCUMENTLISTLINK=true
    fi

    ISSUESLINK=false
    if grep -qs 'href="/servlets/ProjectIssues"' $file
    then
        ISSUESLINK=true
    fi

    {
        cat <<EOF
<!-- \$Id\$ -->
<!-- This files is generated from the generate-project-tools.sh script. -->
  <ul>
EOF

        if $NEWSLISTLINK
        then
            cat <<EOF
    <li><a href="/servlets/ProjectNewsList">$T_NEWS</a></li>
EOF
        fi

        cat <<EOF
    <li><a href="/servlets/ProjectMemberList">$T_MEMBERSHIP ($NAME)</a></li>
EOF

        if $ISSUESLINK
        then
            cat <<EOF
    <li><a href="/servlets/ProjectIssues">$T_ISSUES ($NAME)</a></li>
EOF
        fi

        cat <<EOF
    <li><a href="/ds/viewForums.do">$T_MAILING_LISTS ($NAME)</a></li>
EOF

        if $PROJECTDOCUMENTLISTLINK
        then
            cat <<EOF
    <li><a href="/servlets/ProjectDocumentList">$T_FILES ($NAME)</a></li>
EOF
        fi

        cat <<EOF
    <li><a href="/source/browse/$i/">$T_SOURCE ($NAME)</a></li>$EXTRA
  </ul>
</dd>

<dt>$T_ARGOUML_PROJECT</dt>
<dd>
  <ul>
    <li><a href="http://argouml.tigris.org/">Project home</a></li>
  </ul>
</dd>
<dd>
  <ul>
    <li>
      <a href="http://argouml.tigris.org/servlets/ProjectNewsList">ArgoUML News</a>
      <a href="http://argouml.tigris.org/servlets/WebFeed?artifact=news&version=rss_2.0">
        <img src="http://argouml.tigris.org/images/feed-icon.gif" alt="RSS Feed" width="10" height="10"/>
      </a>
    </li>
    <li>
      <a href="http://argouml.tigris.org/wiki">Developer Wiki</a>
      <a href="http://argouml.tigris.org/wiki/RecentChanges">RC</a>
    </li>
    <li><a href="http://argouml.tigris.org/project_bugs.html">Bugs and Issues</a></li>
    <li><a href="http://argouml.tigris.org/source/browse/argouml/trunk/src/">Source Code</a></li>
    <li><a href="http://argouml.tigris.org/servlets/ProjectMemberList">Project Membership</a></li>
    <li>
      <a href="http://argouml.tigris.org/ds/viewForums.do">$T_ARGOUML_MAILING_LISTS</a>
      <a href="http://argouml.markmail.org">MarkMail</a>
    </li>
    <li><a href="http://argouml.tigris.org/servlets/ProjectDocumentList">File Sharing</a></li>
  </ul>

<dt>$T_ARGOUML_USING_ARGOUML</dt> 
<dd> 
  <ul> 
    <li><a href="http://argouml.tigris.org/support.html">Support</a></li> 
    <li><a href="http://argouml-stats.tigris.org/documentation/quickguide-0.30/">$T_ARGOUML_QUICK_GUIDE 0.30</a></li> 
    <li><a href="http://argouml-stats.tigris.org/documentation/manual-0.30/">$T_ARGOUML_USER_MANUAL 0.30</a></li> 
    <li><a href="http://argouml.tigris.org/faqs/users.html">$T_ARGOUML_FAQ</a></li> 
    <li><a href="http://www.argouml-users.net/" target="wiki">$T_ARGOUML_WIKI</a></li> 
    <li><a href="http://www.argouml-users.net/forum" target="forum">$T_ARGOUML_FORUM</a></li> 
    <li><a href="http://argouml.tigris.org/servlets/SummarizeList?listName=users">$T_ARGOUML_USERS_MAILING_LIST</a></li> 
    <li><a href="http://argouml.tigris.org/documentation/">$T_ARGOUML_DOCUMENTATION</a></li> 
    <li><a href="http://argouml.tigris.org/tours/">$T_ARGOUML_TOUR</a></li> 
    <li><a href="http://argouml-downloads.tigris.org/">$T_ARGOUML_DOWNLOADS</a></li>$USING_EXTRA
  </ul> 

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-682460-2";
urchinTracker();
</script>
EOF
    } |
    cat > $file

    if svn status $file | egrep -qs '[?AM]'
    then
	svn diff -x -w $file
	echo -n "Replace? N/Y/Q "
	read ans
	case "$ans" in
	Y)
	    svn commit -m"Update to the file created by the generate-project-tools.sh script.
    $*" $file
	    ;;
        Q)
            svn revert $file
            break
            ;;
	*)
	    svn revert $file
	    ;;
	esac
    fi
    echo $i...done
done

#!/bin/sh

for i in argouml-*
do
    name=`echo $i | sed 's/^argouml-//'`
    NAME=`echo $name | tr a-z A-Z`

    file=$i/www/project_tools.html
    if test ! -f $file
    then
        echo $file does not exist
        sleep 1
        continue
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
    <li><a href="/servlets/ProjectMemberList">Membership ($NAME)</a></li>
EOF

        if $ISSUESLINK
        then
            cat <<EOF
    <li><a href="/servlets/ProjectIssues">Issues ($NAME)</a></li>
EOF
        fi

        cat <<EOF
    <li><a href="/ds/viewForums.do">Mailing lists ($NAME)</a></li>
EOF

        if $PROJECTDOCUMENTLISTLINK
        then
            cat <<EOF
    <li><a href="/servlets/ProjectDocumentList">Files ($NAME)</a></li>
EOF
        fi

        cat <<EOF
    <li><a href="/source/browse/argouml-$name/">Source ($NAME)</a></li>
  </ul>
</dd>

<dt>The ArgoUML Project</dt>
<dd>
  <ul>
    <li><a href="http://argouml.tigris.org/">ArgoUML Home</a></li>
    <li><a href="http://argouml.tigris.org/servlets/ProjectNewsList">ArgoUML News</a></li>
    <li><a href="http://argouml.tigris.org/project_bugs.html">Bugs and Issues</a></li>
    <li><a href="http://argouml.tigris.org/wiki">Developer Wiki</a></li>
    <li><a href="http://argouml.tigris.org/dev.html">Developer Zone</a></li>
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

    if svn status $file | grep -qs M
    then
	svn diff -x -w $file
	echo -n "Replace? N/Y "
	read ans
	case "$ans" in
	Y)
	    svn commit -m"Update to the file created by the generate-project-tools.sh script.
    $*" $file
	    ;;
	*)
	    svn revert $file
	    ;;
	esac
    fi
done

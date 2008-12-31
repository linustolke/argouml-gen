#!/bin/sh

for i in argouml-*
do
    name=`echo $i | sed 's/^argouml-//'`
    NAME=`echo $name | tr a-z A-Z`

    PROJECTDOCUMENTLISTLINK=false
    if grep -qs 'href="/servlets/ProjectDocumentList"' $i/www/project_tools.html
    then
        PROJECTDOCUMENTLISTLINK=true
    fi

    {
        cat <<EOF
<!-- \$Id\$ -->
  <ul>
    <li><a href="/servlets/ProjectMemberList">Membership ($NAME)</a></li>
    <li><a href="/servlets/ProjectMailingListList">Mailing lists ($NAME)</a></li>
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
    <li><a href="http://argouml.tigris.org/dev.html">Developer Zone</a></li>
  </ul>
EOF
    } |
    cat > $i/www/project_tools.html
done

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
      <a href="http://argouml.tigris.org/ds/viewForums.do">Mailing lists</a>
      <a href="http://argouml.markmail.org">MarkMail</a>
    </li>
    <li><a href="http://argouml.tigris.org/servlets/ProjectDocumentList">File Sharing</a></li>
  </ul>

<dt>Using ArgoUML</dt> 
<dd> 
  <ul> 
    <li><a href="http://argouml.tigris.org/support.html">Support</a></li> 
    <li><a href="http://argouml-stats.tigris.org/documentation/quick-guide-0.28/">Quick guide 0.28</a></li> 
    <li><a href="http://argouml-stats.tigris.org/documentation/manual-0.28/">User Manual 0.28</a></li> 
    <li><a href="http://argouml.tigris.org/faqs/users.html">FAQ</a></li> 
    <li><a href="http://www.argouml-users.net/" target="wiki">Wiki</a></li> 
    <li><a href="http://www.argouml-users.net/forum" target="forum">Forum</a></li> 
    <li><a href="http://argouml.tigris.org/servlets/SummarizeList?listName=users">Users' mailing list</a></li> 
    <li><a href="http://argouml.tigris.org/documentation/">Documentation</a></li> 
    <li><a href="http://argouml.tigris.org/tours/">Tour</a></li> 
    <li><a href="http://argouml-downloads.tigris.org/">Downloads</a></li> 
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

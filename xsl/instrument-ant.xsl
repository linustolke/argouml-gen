<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="todir"/>

<xsl:template match="/">
  <project name="instrument-ant" default="instrument-ant">
    <target name="instrument-ant">
      <!-- Create 'add' tasks. -->
      <xsl:for-each select="//pathelement">
        <instrument>
          <xsl:attribute name="todir"><![CDATA[${argo-gen.jcoverage.instrumented.classes}]]></xsl:attribute>
          <!--
            Note that the following line causes instrument to ignore any
            source line containing a reference to log4j, for the purposes
            of coverage reporting.
          -->
          <ignore regex="org.apache.log4j.*"/>

          <fileset>
            <xsl:attribute name="dir"><![CDATA[${argo.build.classes}]]></xsl:attribute>
            <include>
              <xsl:attribute name="name"><xsl:value-of select="."/>/*.class</xsl:attribute>
            </include>
          </fileset>
        </instrument>
      </xsl:for-each>
    </target>
  </project>
</xsl:template>

</xsl:stylesheet>

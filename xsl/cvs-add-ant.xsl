<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="todir"/>

<xsl:template match="/">
  <project name="cvs-add-ant" default="cvs-add-ant">
    <target name="cvs-add-ant">
      <!-- Create 'add' tasks. -->
      <xsl:for-each select="//pathelement[not(.='')]">
        <xsl:if test="count(document($todir)//pathelement[.=current()])=0">
          <echo>Adding <xsl:value-of select="."/></echo>
          <cvs>
            <xsl:attribute name="command">add <xsl:value-of select="."/></xsl:attribute>
            <xsl:attribute name="cvsRoot"><![CDATA[${cvs.root}]]></xsl:attribute>
          </cvs>
        </xsl:if>
      </xsl:for-each>
    </target>
  </project>
</xsl:template>

</xsl:stylesheet>

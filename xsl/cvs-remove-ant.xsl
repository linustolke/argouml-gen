<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="fromdir"/>

<xsl:template match="/">
  <project name="cvs-remove" default="cvs-remove">
    <target name="cvs-remove">
      <!-- Create 'remove' tasks. -->
      <xsl:for-each select="//pathelement[not(.='')]">
        <xsl:if test="count(document($fromdir)//pathelement[.=current()])=0">
          <echo>Removing <xsl:value-of select="."/></echo>
          <cvs>
            <xsl:attribute name="command">remove -f <xsl:value-of select="."/></xsl:attribute>
            <xsl:attribute name="cvsRoot"><![CDATA[${cvs.root}]]></xsl:attribute>
          </cvs>
        </xsl:if>
      </xsl:for-each>
    </target>
  </project>
</xsl:template>

</xsl:stylesheet>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:redirect="http://xml.apache.org/xalan/redirect"
    extension-element-prefixes="redirect">

<!--
 The Apache Software License, Version 1.1

 Copyright (c) 2002 The Apache Software Foundation.  All rights
 reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

 3. The end-user documentation included with the redistribution, if
    any, must include the following acknowlegement:
       "This product includes software developed by the
        Apache Software Foundation (http://www.apache.org/)."
    Alternately, this acknowlegement may appear in the software itself,
    if and wherever such third-party acknowlegements normally appear.

 4. The names "The Jakarta Project", "Ant", and "Apache Software
    Foundation" must not be used to endorse or promote products derived
    from this software without prior written permission. For written
    permission, please contact apache@apache.org.

 5. Products derived from this software may not be called "Apache"
    nor may "Apache" appear in their names without prior written
    permission of the Apache Group.

 THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
 ====================================================================

 This software consists of voluntary contributions made by many
 individuals on behalf of the Apache Software Foundation.  For more
 information on the Apache Software Foundation, please see
 <http://www.apache.org/>.
 -->

    <xsl:output method="html" indent="yes" encoding="US-ASCII"/>
    <xsl:decimal-format decimal-separator="." grouping-separator="," />

    <xsl:param name="output.dir" select="'.'"/>
    <xsl:param name="messages.xml"/>

    <xsl:variable name="main" select="/"/>
    <xsl:variable name="messages" select="document($messages.xml)"/>
    
    <xsl:template match="BugCollection">
        <!-- create the index.html -->
        <redirect:write file="{$output.dir}/index.html">
            <xsl:call-template name="index.html"/>
        </redirect:write>

        <!-- create the stylesheet.css -->
        <redirect:write file="{$output.dir}/stylesheet.css">
            <xsl:call-template name="stylesheet.css"/>
        </redirect:write>

        <!-- create the overview-summary.html at the root -->
        <redirect:write file="{$output.dir}/overview-frame.html">
            <xsl:apply-templates select="." mode="overview"/>
        </redirect:write>

        <!-- create the all-classes.html at the root -->
        <redirect:write file="{$output.dir}/allclasses-frame.html">
            <xsl:apply-templates select="." mode="all.classes"/>
        </redirect:write>

        <!-- process all files -->
        <xsl:call-template name="bug-files"/>
    </xsl:template>

    <xsl:template name="index.html">
        <html>
            <head>
                <title>FindBugs Audit</title>
            </head>
            <frameset cols="20%,80%">
                <frame src="allclasses-frame.html" name="fileListFrame"/>
                <frame src="overview-frame.html" name="fileFrame"/>
            </frameset>
            <noframes>
                <h2>Frame Alert</h2>
                <p>
                    This document is designed to be viewed using the frames feature. If you see this message, you are using a non-frame-capable web client.
                </p>
            </noframes>
        </html>
    </xsl:template>

    <xsl:template name="pageHeader">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="text-align:right"><h2>FindBugs Audit</h2></td>
            </tr>
            <tr>
                <td class="text-align:right">Designed for use with <a href='http://findbugs.sourceforge.net/'>FindBugs</a> and <a href='http://jakarta.apache.org'>Ant</a>.
                Adapted from  <a href='http://checkstyle.sourceforge.net/'>CheckStyle</a>.
                </td>
            </tr>
        </table>
        <hr size="1"/>
    </xsl:template>

    <xsl:template match="BugCollection" mode="overview">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="stylesheet.css"/>
            </head>
            <body>
                <!-- page header -->
                <xsl:call-template name="pageHeader"/>

                <!-- Summary part -->
                <xsl:apply-templates select="." mode="summary"/>
                <hr size="1" width="100%" align="left"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="stylesheet.css">
        .bannercell {
        border: 0px;
        padding: 0px;
        }
        body {
        margin-left: 10;
        margin-right: 10;
        font:normal 80% arial,helvetica,sanserif;
        background-color:#FFFFFF;
        color:#000000;
        }
        .a td {
        background: #efefef;
        }
        .b td {
        background: #fff;
        }
        th, td {
        text-align: left;
        vertical-align: top;
        }
        th {
        font-weight:bold;
        background: #ccc;
        color: black;
        }
        table, th, td {
        font-size:100%;
        border: none
        }
        table.log tr td, tr th {

        }
        h2 {
        font-weight:bold;
        font-size:140%;
        margin-bottom: 5;
        }
        h3 {
        font-size:100%;
        font-weight:bold;
        background: #525D76;
        color: white;
        text-decoration: none;
        padding: 5px;
        margin-right: 2px;
        margin-left: 2px;
        margin-bottom: 0;
        }
    </xsl:template>
    
    <!--
    Creates an all-classes.html file that contains a link to all files.
    -->
    <xsl:template match="BugCollection" mode="all.classes">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="stylesheet.css"/>
            </head>
            <body>
                <h2>Bugs</h2>
                <p><a href="overview-frame.html" target="fileFrame">Summary</a></p>
                <p>
                    <table width="100%">
                        <!-- For each file create its part -->
                        <xsl:for-each select="$messages//BugPattern">
                          <xsl:sort select="ShortDescription"/>
                          <xsl:variable name="type" select="@type"/>
                          <xsl:if test="count($main//BugInstance[@type=$type])>0">
                          <tr>
                            <td nowrap="nowrap">
                              <a target="fileFrame">
                                <xsl:attribute name="href">
                                    <xsl:text>files/</xsl:text><xsl:value-of select="$type"/><xsl:text>.html</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="ShortDescription"/>
                              </a>
                            </td>
                          </tr>
                          </xsl:if>
                        </xsl:for-each>
                        
                        <!--xsl:apply-templates select="BugInstance" mode="all.classes">
                            <xsl:sort select="."/>
                        </xsl:apply-templates-->
                     </table>
                </p>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="BugCollection" mode="filelist">
        <h3>Files</h3>
        <table class="log" border="0" cellpadding="5" cellspacing="2" width="100%">
            <tr>
                <th>Name</th>
                <th>Errors</th>
            </tr>
            <xsl:apply-templates select="file" mode="filelist">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <xsl:template match="BugInstance" mode="all.classes">
        <xsl:variable name="first">
            <xsl:call-template name="isfirst">
                <xsl:with-param name="type" select="@type"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$first = 'true'">
            <tr>
                <td nowrap="nowrap">
                    <a target="fileFrame">
                        <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
                        <xsl:attribute name="href">
                            <xsl:text>files/</xsl:text><xsl:value-of select="@type"/><xsl:text>.html</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$messages//BugPattern[@type=$type]/ShortDescription"/>
                        </a>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="bug-files">
      <xsl:for-each select="$messages//BugPattern">
          <xsl:variable name="type" select="@type"/>
          <xsl:variable name="ShortDescription" select="ShortDescription"/>
          <xsl:variable name="bugCount" select="count($main//BugInstance[@type=$type])"/>
          <xsl:if test="$bugCount > 0">
            <redirect:write file="{$output.dir}/files/{$type}.html">
                <html>
                    <head>
                        <link rel="stylesheet" type="text/css">
                            <xsl:attribute name="href">../<xsl:text>stylesheet.css</xsl:text></xsl:attribute>
                        </link>
                    </head>
                    <body>
                        <xsl:call-template name="pageHeader"/>
                        <h3><xsl:value-of select="ShortDescription"/></h3>
                        
                        <!-- Yeah. This sucks. -->
                        <xsl:variable name="desc1">
                          <xsl:call-template name="processDetailsParagraphs">
                            <xsl:with-param name="details">
                              <xsl:call-template name="processDetailsNbsp">
                                <xsl:with-param name="details" select="Details"/>
                              </xsl:call-template>
                            </xsl:with-param>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="desc2">
                          <xsl:call-template name="processDetailsCode">
                            <xsl:with-param name="details" select="$desc1"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="desc3">
                          <xsl:call-template name="processDetailsEm">
                            <xsl:with-param name="details" select="$desc2"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="desc4">
                          <xsl:call-template name="processDetailsUl">
                            <xsl:with-param name="details" select="$desc2"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="desc5">
                          <xsl:call-template name="processDetailsLi">
                            <xsl:with-param name="details" select="$desc4"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$desc4"/>
                        
                        <table class="log" border="0" cellpadding="5" cellspacing="2" width="100%">
                            <tr>
                              <xsl:for-each select="$main//BugInstance[@type=$type][1]/*">
                                <th><xsl:value-of select="name()"/></th>
                               </xsl:for-each>
                            </tr>
                              <xsl:for-each select="$main//BugInstance[@type=$type]">
                                <tr>
                                    <xsl:for-each select="*">
                                      <td>
                                        <xsl:call-template name="alternated-row"/>
                                        <xsl:choose>
                                          <xsl:when test="name()='Class'">
                                            <xsl:value-of select="@classname"/>
                                          </xsl:when>
                                          <xsl:when test="name()='Method'">
                                            <xsl:value-of select="@name"/>
                                          </xsl:when>
                                          <xsl:when test="name()='Field'">
                                            <xsl:value-of select="@name"/>
                                          </xsl:when>
                                          <xsl:when test="name()='SourceLine'">
                                            <xsl:if test="@start = @end">
                                              <xsl:value-of select="@start"/>
                                            </xsl:if>
                                            <xsl:if test="not(@start = @end)">
                                              <xsl:value-of select="@start"/>-<xsl:value-of select="@end"/>
                                            </xsl:if>
                                          </xsl:when>
                                          <xsl:otherwise><![CDATA[ ]]></xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                    </xsl:for-each>
                                </tr>
                               </xsl:for-each>
                        </table>
                    </body>
                </html>
            </redirect:write>
        </xsl:if>
      </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="processDetailsParagraphs">
      <xsl:param name="details"/>
      <xsl:if test="contains($details,'&lt;p&gt;')">
        <xsl:element name="p"><xsl:value-of select="substring-before($details,'&lt;p&gt;')"/></xsl:element>
        <xsl:call-template name="processDetailsParagraphs">
          <xsl:with-param name="details" select="substring-after($details,'&lt;p&gt;')"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not(contains($details,'&lt;p&gt;')) and string-length($details) > 0">
        <xsl:element name="p"><xsl:value-of select="$details"/></xsl:element>
      </xsl:if>
    </xsl:template>

    <xsl:template name="processDetailsNbsp">
      <xsl:param name="details"/>
      <xsl:if test="contains($details,'&amp;nbsp;')">
        <xsl:value-of select="substring-before($details,'&amp;nbsp;')"/><xsl:text> </xsl:text>
        <xsl:call-template name="processDetailsNbsp">
          <xsl:with-param name="details" select="substring-after($details,'&amp;nbsp;')"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not(contains($details,'&amp;nbsp;')) and string-length($details) > 0">
        <xsl:value-of select="$details"/>
      </xsl:if>
    </xsl:template>

    <xsl:template name="processDetailsCode">
      <xsl:param name="details"/>
      <xsl:variable name="entity-start">&lt;code&gt;</xsl:variable>
      <xsl:variable name="entity-end">&lt;/code&gt;</xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($details,$entity-start)">
          <xsl:value-of select="substring-before($details,$entity-start)"/>
          <xsl:element name="code">
            <xsl:value-of select="substring-before(substring-after($details,$entity-start),$entity-end)"/>
          </xsl:element>
          <xsl:call-template name="processDetailsCode">
            <xsl:with-param name="details" select="substring-after($details,$entity-end)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$details"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="processDetailsEm">
      <xsl:param name="details"/>
      <xsl:variable name="entity-start">&lt;EM&gt;</xsl:variable>
      <xsl:variable name="entity-end">&lt;/EM&gt;</xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($details,$entity-start)">
          <xsl:value-of select="substring-before($details,$entity-start)"/>
          <xsl:element name="em">
            <xsl:value-of select="substring-before(substring-after($details,$entity-start),$entity-end)"/>
          </xsl:element>
          <xsl:call-template name="processDetailsEm">
            <xsl:with-param name="details" select="substring-after($details,$entity-end)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$details"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="processDetailsUl">
      <xsl:param name="details"/>
      <xsl:variable name="entity-start">&lt;ul&gt;</xsl:variable>
      <xsl:variable name="entity-end">&lt;/ul&gt;</xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($details,$entity-start)">
          <xsl:value-of select="substring-before($details,$entity-start)"/>
          <xsl:element name="ul">
            <xsl:value-of select="substring-before(substring-after($details,$entity-start),$entity-end)"/>
          </xsl:element>
          <xsl:call-template name="processDetailsUl">
            <xsl:with-param name="details" select="substring-after($details,$entity-end)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$details"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="processDetailsLi">
      <xsl:param name="details"/>
      <xsl:if test="contains($details,'&lt;li&gt;')">
        <xsl:value-of select="substring-before($details,'&lt;li&gt;')"/><xsl:text> </xsl:text>
        <xsl:call-template name="processDetailsNbsp">
          <xsl:with-param name="details" select="substring-after($details,'&amp;nbsp;')"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not(contains($details,'&amp;nbsp;')) and string-length($details) > 0">
        <xsl:value-of select="$details"/>
      </xsl:if>
    </xsl:template>


    <xsl:template match="BugCollection" mode="summary">
        <h3>Summary</h3>
        <table class="log" border="0" cellpadding="5" cellspacing="2" width="100%">
            <tr>
                <th>Errors</th>
                <th>Pri</th>
                <th>#Errors</th>
            </tr>

            <xsl:for-each select="BugInstance">
                <xsl:sort select="@priority" data-type="number"/>
                <xsl:sort select="count(following-sibling::BugInstance[@type=current()/@type])"
                     order="descending" data-type="number"/>
                <xsl:variable name="first">
                  <xsl:call-template name="isfirst">
                      <xsl:with-param name="type" select="@type"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:if test="$first = 'true'">
                  <xsl:variable name="type" select="@type"/>
                  <xsl:variable name="ShortDescription" select="$messages//BugPattern[@type=$type]/ShortDescription"/>
                  <xsl:variable name="bugCount" select="count(//BugInstance[@type=$type])"/>
                  <xsl:if test="$bugCount > 0">
                    <tr>
                      <!--xsl:call-template name="alternated-row"/-->
                      <td><a><xsl:attribute name="href">files/<xsl:value-of select="$type"/>.html</xsl:attribute><xsl:value-of select="$ShortDescription"/></a></td>
                      <td><xsl:value-of select="@priority"/></td>
                      <td><xsl:value-of select="$bugCount"/></td>
                    </tr>
                  </xsl:if>
                </xsl:if>
            </xsl:for-each>
            <!--xsl:for-each select="$messages//BugPattern">
                <xsl:variable name="ShortDescription" select="ShortDescription"/>
                <xsl:variable name="type" select="@type"/>
                <xsl:variable name="bugCount" select="count($main//BugInstance[@type=$type])"/>
                <xsl:if test="$bugCount > 0">
                  <tr>
                    <xsl:call-template name="alternated-row"/>
                    <td><a><xsl:attribute name="href">files/<xsl:value-of select="$type"/>.html</xsl:attribute><xsl:value-of select="$ShortDescription"/></a></td>
                    <td><xsl:value-of select="$bugCount"/></td>
                  </tr>
                </xsl:if-->
        </table>
    </xsl:template>

    <xsl:template name="alternated-row">
        <xsl:attribute name="class">
            <xsl:if test="position() mod 2 = 1">a</xsl:if>
            <xsl:if test="position() mod 2 = 0">b</xsl:if>
        </xsl:attribute>
    </xsl:template>

    <!-- determine if this is the first occurance of the given name in the input -->
    <xsl:template name="isfirst">
        <xsl:param name="type"/>
        <xsl:value-of select="count(preceding-sibling::BugInstance[@type=$type]) = 0"/>
    </xsl:template>

</xsl:stylesheet>


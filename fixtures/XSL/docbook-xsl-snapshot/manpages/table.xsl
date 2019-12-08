<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl d"
                version='1.0'>

  <!-- ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://cdn.docbook.org/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->
  <!--
  <xsl:import href="http://cdn.docbook.org/release/xsl/current/html/docbook.xsl"/>
  <xsl:param name="tbl.font.title">B</xsl:param>
  <xsl:param name="tbl.font.headings">B</xsl:param>
  -->
  <!-- import the templates that match on non-namespace HTML
  elements and produce tbl markup. They
  are separated so the namespace prefix is not added to them. -->
  <xsl:include href="tbl.xsl"/>

  <xsl:param name="tbl.running.header.from.thead" select="0"/>
  <xsl:param name="tbl.column.separator.char">:</xsl:param>

  <!-- ==================================================================== -->

  <!-- * This stylesheet transforms DocBook and HTML table source into -->
  <!-- * tbl(1) markup. -->
  <!-- * -->
  <!-- * For details on tbl(1) and its markup syntaxt, see M. E. Lesk,-->
  <!-- * "Tbl - A Program to Format Tables": -->
  <!-- * -->
  <!-- *   http://cm.bell-labs.com/7thEdMan/vol2/tbl -->
  <!-- *   http://cm.bell-labs.com/cm/cs/doc/76/tbl.ps.gz -->
  <!-- *   http://www.snake.net/software/troffcvt/tbl.html -->

  <xsl:template match="d:table|d:informaltable" mode="to.tbl">
    <!--* the "source" param is an optional param; it can be any -->
    <!--* string you want to use that gives some indication of the -->
    <!--* source context for a table; it gets passed down to the named -->
    <!--* templates that do the actual table processing; this -->
    <!--* stylesheet currently uses the "source" information for -->
    <!--* logging purposes -->
    <xsl:param name="source"/>
    <xsl:param name="title">
      <xsl:if test="local-name(.) = 'table'">
        <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
      </xsl:if>
    </xsl:param>
    <!-- * ============================================================== -->
    <!-- *    Set global table parameters                                 -->
    <!-- * ============================================================== -->
    <!-- * First, set a few parameters based on attributes specified in -->
    <!-- * the table source. -->
    <xsl:param name="allbox">
    <xsl:if test="not(@frame = 'none') and not(@border = '0')">
      <!-- * By default, put a box around table and between all cells, -->
      <!-- * unless frame="none" or border="0" -->
      <xsl:text>allbox </xsl:text>
    </xsl:if>
    </xsl:param>
    <xsl:param name="center">
    <!-- * If align="center", center the table. Otherwise, tbl(1) -->
    <!-- * left-aligns it by default; note that there is no support -->
    <!-- * in tbl(1) for specifying right alignment. -->
    <xsl:if test="@align = 'center' or d:tgroup/@align = 'center'">
      <xsl:text>center </xsl:text>
    </xsl:if>
    </xsl:param>
    <xsl:param name="expand">
    <!-- * If pgwide="1" or width="100%", then "expand" the table by -->
    <!-- * making it "as wide as the current line length" (to quote -->
    <!-- * the tbl(1) guide). -->
    <xsl:if test="@pgwide = '1' or @width = '100%'">
      <xsl:text>expand </xsl:text>
    </xsl:if>
    </xsl:param>

    <!-- * ============================================================== -->
    <!-- *    Convert table to HTML                                       -->
    <!-- * ============================================================== -->
    <!-- * Process the table by applying the HTML templates from the -->
    <!-- * DocBook XSL stylesheets to the whole thing; because we don't -->
    <!-- * override any of the <row>, <entry>, <tr>, <td>, etc. templates, -->
    <!-- * the templates in the HTML stylesheets (which we import) are -->
    <!-- * used to process those. -->
    <xsl:param name="html-table-output">
      <xsl:choose>
        <xsl:when test=".//d:tr">
          <!-- * If this table has a TR child, it means that it's an -->
          <!-- * HTML table in the DocBook source, instead of a CALS -->
          <!-- * table. So we just copy it as-is, while wrapping it -->
          <!-- * in an element with same name as its original parent. -->
          <xsl:for-each select="descendant-or-self::d:table|descendant-or-self::d:informaltable">
            <xsl:element name="{local-name(..)}">
              <table>
                <!-- strip namespace from docbook HTML table markup if present -->
                <xsl:apply-templates mode="strip.html.table.ns" select="*"/>
                <xsl:if test=".//d:footnote|../d:title//d:footnote">
                  <tbody class="footnotes">
                    <tr>
                      <td colspan="{@cols}">
                        <xsl:apply-templates select=".//d:footnote|../d:title//d:footnote" mode="table.footnote.mode"/>
                      </td>
                    </tr>
                  </tbody>
                </xsl:if>
              </table>
            </xsl:element>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <!-- * Otherwise, this is a CALS table in the DocBook source, -->
          <!-- * so we need to apply the templates in the HTML -->
          <!-- * stylesheets to transform it into HTML before we do -->
          <!-- * any further processing of it. -->
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="contents" select="exsl:node-set($html-table-output)"/>

    <xsl:call-template name="htmltotbl">
      <xsl:with-param name="source" select="$source"/>
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="contents" select="$contents"/>
      <xsl:with-param name="allbox" select="$allbox"/>
      <xsl:with-param name="expand" select="$expand"/>
      <xsl:with-param name="center" select="$center"/>
    </xsl:call-template>
  </xsl:template>

<!-- strip namespace only from docbook html markup elements -->
<xsl:template match="d:tbody
                    |d:caption
                    |d:col
                    |d:colgroup
                    |d:thead
                    |d:tfoot
                    |d:tr
                    |d:th
                    |d:td" mode="strip.html.table.ns">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*[not(name(.) = 'xml:id')
                            and not(name(.) = 'version')]"/>
    <xsl:if test="@xml:id">
      <xsl:attribute name="id">
        <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="strip.html.table.ns"/>
  </xsl:element>
</xsl:template>

<!-- do not strip namespace from cell contents -->
<xsl:template match="*|text()|processing-instruction()|comment()" mode="strip.html.table.ns">
  <!-- process in normal mode -->
  <xsl:apply-templates select="."/>
  <!--
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="strip.html.table.ns"/>
  </xsl:copy>
  -->
</xsl:template>

</xsl:stylesheet>

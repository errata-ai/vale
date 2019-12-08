<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "../common/entities.ent">
%common.entities;
]>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
  xmlns:xtbl="xalan://com.nwalsh.xalan.Table"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:ptbl="http://nwalsh.com/xslt/ext/xsltproc/python/Table"
  exclude-result-prefixes="exsl stbl xtbl lxslt ptbl d"
  version="1.0">

<!-- $I html5-element-mods.xsl,v 1.2 2011-09-18 17:47:28 bobs Exp $ -->

<!--==============================================================-->
<!--  DocBook XSL Parameter settings                              -->
<!--==============================================================-->
<!-- Set these to blank so can output special HTML5 empty DOCTYPE -->
<xsl:param name="chunker.output.doctype-system" select="''"/>
<xsl:param name="chunker.output.doctype-public" select="''"/>

<xsl:param name="table.borders.with.css" select="1"/>
<xsl:param name="html.ext">.xhtml</xsl:param>
<xsl:param name="toc.list.type">ul</xsl:param>
<xsl:param name="css.decoration" select="1"/>
<xsl:param name="make.clean.html" select="1"/>
<xsl:param name="generate.id.attributes" select="1"/>
<xsl:variable name="div.element">section</xsl:variable>

<!--==============================================================-->
<!--  Customized templates                                        -->
<!--==============================================================-->

<!-- HTML5: needs special doctype -->
<xsl:template name="user.preroot">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
</xsl:template>

<!-- HTML5: Replace HTML acronum with abbr for HTML 5 -->
<xsl:template match="d:acronym">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="wrapper-name">abbr</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- HTML5: replace border="0" with border="" -->
<!-- HTML5: No @summary allowed -->
<!-- HTML5: replace many table atts with CSS styles -->
<xsl:template match="d:tgroup" name="tgroup">
  <xsl:if test="not(@cols) or @cols = '' or string(number(@cols)) = 'NaN'">
    <xsl:message terminate="yes">
      <xsl:text>Error: CALS tables must specify the number of columns.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="summary">
    <xsl:call-template name="pi.dbhtml_table-summary"/>
  </xsl:variable>

  <xsl:variable name="cellspacing">
    <xsl:call-template name="pi.dbhtml_cellspacing"/>
  </xsl:variable>

  <xsl:variable name="cellpadding">
    <xsl:call-template name="pi.dbhtml_cellpadding"/>
  </xsl:variable>

  <!-- First generate colgroup with attributes -->
  <xsl:variable name="colgroup.with.attributes">
    <colgroup>
      <xsl:call-template name="generate.colgroup">
        <xsl:with-param name="cols" select="@cols"/>
      </xsl:call-template>
    </colgroup>
  </xsl:variable>

  <!-- then modify colgroup attributes with extension -->
  <xsl:variable name="colgroup.with.extension">
    <xsl:choose>
      <xsl:when test="$use.extensions != 0
                      and $tablecolumns.extension != 0">
        <xsl:choose>
          <xsl:when test="function-available('stbl:adjustColumnWidths')">
            <xsl:copy-of select="stbl:adjustColumnWidths($colgroup.with.attributes)"/>
          </xsl:when>
          <xsl:when test="function-available('xtbl:adjustColumnWidths')">
            <xsl:copy-of select="xtbl:adjustColumnWidths($colgroup.with.attributes)"/>
          </xsl:when>
          <xsl:when test="function-available('ptbl:adjustColumnWidths')">
            <xsl:copy-of select="ptbl:adjustColumnWidths($colgroup.with.attributes)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes">
              <xsl:text>No adjustColumnWidths function available.</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$colgroup.with.attributes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Now convert to @style -->
  <xsl:variable name="colgroup">
    <xsl:call-template name="colgroup.with.style">
      <xsl:with-param name="colgroup" select="$colgroup.with.extension"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="explicit.table.width">
    <xsl:call-template name="pi.dbhtml_table-width">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="table.width.candidate">
    <xsl:choose>
      <xsl:when test="$explicit.table.width != ''">
        <xsl:value-of select="$explicit.table.width"/>
      </xsl:when>
      <xsl:when test="$default.table.width = ''">
        <xsl:text>100%</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default.table.width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="table.width">
    <xsl:if test="$default.table.width != ''
                  or $explicit.table.width != ''">
      <xsl:choose>
        <xsl:when test="contains($table.width.candidate, '%')">
          <xsl:value-of select="$table.width.candidate"/>
        </xsl:when>
        <xsl:when test="$use.extensions != 0
                        and $tablecolumns.extension != 0">
          <xsl:choose>
            <xsl:when test="function-available('stbl:convertLength')">
              <xsl:value-of select="stbl:convertLength($table.width.candidate)"/>
            </xsl:when>
            <xsl:when test="function-available('xtbl:convertLength')">
              <xsl:value-of select="xtbl:convertLength($table.width.candidate)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">
                <xsl:text>No convertLength function available.</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$table.width.candidate"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <!-- assemble a table @style -->
  <xsl:variable name="table.style">

    <xsl:if test="$cellspacing != '' or $html.cellspacing != ''">
      <xsl:text>cellspacing: </xsl:text>
      <xsl:choose>
        <xsl:when test="$cellspacing != ''">
          <xsl:value-of select="$cellspacing"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$html.cellspacing"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>; </xsl:text>
    </xsl:if>

    <xsl:if test="$cellpadding != '' or $html.cellpadding != ''">
      <xsl:text>cellpadding: </xsl:text>
      <xsl:choose>
        <xsl:when test="$cellpadding != ''">
          <xsl:value-of select="$cellpadding"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$html.cellpadding"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>; </xsl:text>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length($table.width) != 0">
        <xsl:text>width: </xsl:text>
        <xsl:value-of select="$table.width"/>
        <xsl:text>; </xsl:text>
      </xsl:when>
      <xsl:when test="../@pgwide=1 or local-name(.) = 'entrytbl'">
        <xsl:text>width: 100%; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="../@frame='all' or (not(../@frame) and $default.table.frame='all')">
        <xsl:text>border-collapse: collapse; </xsl:text>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'top'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'bottom'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'left'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'right'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="../@frame='topbot' or (not(../@frame) and $default.table.frame='topbot')">
        <xsl:text>border-collapse: collapse;</xsl:text>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'top'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'bottom'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="../@frame='top' or (not(../@frame) and $default.table.frame='top')">
        <xsl:text>border-collapse: collapse;</xsl:text>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'top'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="../@frame='bottom' or (not(../@frame) and $default.table.frame='bottom')">
        <xsl:text>border-collapse: collapse;</xsl:text>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'bottom'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="../@frame='sides' or (not(../@frame) and $default.table.frame='sides')">
        <xsl:text>border-collapse: collapse;</xsl:text>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'left'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
        <xsl:call-template name="border">
          <xsl:with-param name="side" select="'right'"/>
          <xsl:with-param name="style" select="$table.frame.border.style"/>
          <xsl:with-param name="color" select="$table.frame.border.color"/>
          <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="../@frame='none'">
        <xsl:text>border: none;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>border-collapse: collapse;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <table>
    <!-- HTML5: no table summary allowed -->
    <xsl:if test="string-length($table.style) != 0">
      <xsl:attribute name="style">
        <xsl:value-of select="$table.style"/>
      </xsl:attribute>
    </xsl:if>


    <xsl:copy-of select="$colgroup"/>

    <xsl:apply-templates select="d:thead"/>
    <xsl:apply-templates select="d:tfoot"/>
    <xsl:apply-templates select="d:tbody"/>

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
</xsl:template>

<!-- HTML5: convert col attributes to col CSS styles -->
<xsl:template name="colgroup.with.style">
  <xsl:param name="colgroup"/>

  <xsl:variable name="colgroup.nodeset" select="exsl:node-set($colgroup)"/>
  <xsl:apply-templates select="$colgroup.nodeset" mode="convert.to.style"/>
</xsl:template>

<xsl:template match="d:colgroup" mode="convert.to.style">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="convert.to.style"/>
  </xsl:copy>
</xsl:template>

<!-- HTML5: converts obsolete HTML attributes to CSS styles -->
<xsl:template match="*" mode="convert.to.style">

  <xsl:variable name="element" select="local-name(.)"/>

  <xsl:variable name="style.from.atts">
    <xsl:for-each select="@*">

      <xsl:choose>
        <!-- width and height attributes are ok for img element -->
        <xsl:when test="local-name() = 'width' and $element != 'img'">
          <xsl:variable name="attvalue" select="normalize-space(.)"/>
          <xsl:text>width: </xsl:text>
          <xsl:value-of select="$attvalue"/>
          <!-- if integer value, add px unit -->
          <xsl:if test="floor($attvalue) = $attvalue">
            <xsl:text>px</xsl:text>
          </xsl:if>
          <xsl:text>; </xsl:text>
        </xsl:when>

        <xsl:when test="local-name() = 'height' and $element != 'img'">
          <xsl:variable name="attvalue" select="normalize-space(.)"/>
          <xsl:text>height: </xsl:text>
          <xsl:value-of select="$attvalue"/>
          <!-- if integer value, add px unit -->
          <xsl:if test="floor($attvalue) = $attvalue">
            <xsl:text>px</xsl:text>
          </xsl:if>
          <xsl:text>; </xsl:text>
        </xsl:when>

        <xsl:when test="local-name() = 'align'">
          <xsl:text>text-align: </xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>; </xsl:text>
        </xsl:when>

        <xsl:when test="local-name() = 'valign'">
          <xsl:text>vertical-align: </xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>; </xsl:text>
        </xsl:when>

        <xsl:when test="local-name() = 'border'">
          <xsl:text>border: </xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>; </xsl:text>
        </xsl:when>

        <xsl:when test="local-name() = 'cellspacing'">
          <xsl:text>border-spacing: </xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>px</xsl:text>
          <xsl:text>; </xsl:text>
        </xsl:when>

        <xsl:when test="local-name() = 'cellpadding'">
          <xsl:text>padding: </xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>px</xsl:text>
          <xsl:text>; </xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <!-- merge existing styles with these new styles -->
  <xsl:variable name="style">
    <xsl:value-of select="concat($style.from.atts, @style)"/>
  </xsl:variable>

  <!-- HTML5: reserved for element name conversion if needed -->
  <xsl:variable name="element.name">
    <xsl:value-of select="local-name(.)"/>
  </xsl:variable>

  <xsl:element name="{$element.name}">
    <xsl:if test="string-length($style) != 0">
      <xsl:attribute name="style">
        <xsl:value-of select="$style"/>
      </xsl:attribute>
    </xsl:if>
    <!-- skip converted atts, and also skip disallowed summary attribute -->
    <xsl:for-each select="@*">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'width' and $element != 'img'"/>
        <xsl:when test="local-name(.) = 'height' and $element != 'img'"/>
        <xsl:when test="local-name(.) = 'summary'"/>
        <xsl:when test="local-name(.) = 'border'"/>
        <xsl:when test="local-name(.) = 'cellspacing'"/>
        <xsl:when test="local-name(.) = 'cellpadding'"/>
        <xsl:when test="local-name(.) = 'style'"/>
        <xsl:when test="local-name(.) = 'align'"/>
        <xsl:when test="local-name(.) = 'valign'"/>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates mode="convert.to.style"/>
  </xsl:element>
</xsl:template>

<!-- HTML5: convert some attributes to CSS style attribute -->
<xsl:template match="d:entry|d:entrytbl">
  <xsl:param name="col">
    <xsl:choose>
      <xsl:when test="@revisionflag">
        <xsl:number from="d:row"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:param name="spans"/>

  
  <!-- Process with stock template -->
  <xsl:variable name="cell">
    <xsl:call-template name="entry">
      <xsl:with-param name="col" select="$col"/>
      <xsl:with-param name="spans" select="$spans"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="cell.nodes" select="exsl:node-set($cell)"/>

  <xsl:apply-templates select="$cell.nodes" mode="convert.to.style"/>

</xsl:template>

<xsl:template match="d:mediaobject|d:inlinemediaobject">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:qandaset">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:calloutlist|d:revhistory|d:footnote|d:figure|d:co">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:revhistory" mode="titlepage.mode">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:variablelist">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:orderedlist[@inheritnum = 'inherit']">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:simplelist">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:blockquote">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:note|d:important|d:warning|d:caution|d:tip">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:funcprototype" mode="ansi-tabular">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template match="d:funcprototype" mode="kr-tabular">
  <xsl:call-template name="convert.styles"/>
</xsl:template>

<xsl:template name="convert.styles">
  <xsl:param name="content">
   <xsl:apply-imports/>
  </xsl:param>
  <xsl:variable name="nodes" select="exsl:node-set($content)"/>

  <xsl:apply-templates mode="convert.to.style" select="$nodes"/>
</xsl:template>

<!-- HTML5: link rel="home" is not permitted -->
<!-- Add support for attributes on <html> element  -->
<xsl:template match="*" mode="process.root">
  <xsl:variable name="doc" select="self::*"/>

  <xsl:call-template name="user.preroot"/>
  <xsl:call-template name="root.messages"/>

  <html>
    <xsl:call-template name="root.attributes"/>
    <head>
      <xsl:call-template name="system.head.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
      <xsl:call-template name="head.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
      <xsl:call-template name="user.head.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
    </head>
    <body>
      <xsl:call-template name="body.attributes"/>
      <xsl:call-template name="user.header.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
      <xsl:apply-templates select="."/>
      <xsl:call-template name="user.footer.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
    </body>
  </html>
  <xsl:value-of select="$html.append"/>
  
  <!-- Generate any css files only once, not once per chunk -->
  <xsl:call-template name="generate.css.files"/>
</xsl:template>

<xsl:template name="root.attributes">
</xsl:template>

<!-- HTML5: uses <ul> instead of <dl> for TOC -->
<xsl:template match="d:question" mode="qandatoc.mode">
  <xsl:variable name="firstch">
    <!-- Use a titleabbrev or title if available -->
    <xsl:choose>
      <xsl:when test="../d:blockinfo/d:titleabbrev">
        <xsl:apply-templates select="../d:blockinfo/d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:blockinfo/d:title">
        <xsl:apply-templates select="../d:blockinfo/d:title[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:info/d:titleabbrev">
        <xsl:apply-templates select="../d:info/d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:titleabbrev">
        <xsl:apply-templates select="../d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:info/d:title">
        <xsl:apply-templates select="../d:info/d:title[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:title">
        <xsl:apply-templates select="../d:title[1]/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="(*[local-name(.)!='label'])[1]/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]
                              /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <li>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="label.markup"/>
      <xsl:if test="contains($deflabel,'number') and not(d:label)">
        <xsl:apply-templates select="." mode="intralabel.punctuation"/>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$firstch"/>
    </a>
    <!-- * include nested qandaset/qandaentry in TOC if user wants it -->

    <xsl:if test="not($qanda.nested.in.toc = 0)">
      <xsl:apply-templates select="following-sibling::d:answer" mode="qandatoc.mode"/>
    </xsl:if>
  </li>
</xsl:template>

<xsl:template match="d:answer" mode="qandatoc.mode">
  <xsl:if test="descendant::d:question">
    <xsl:call-template name="process.qanda.toc"/>
  </xsl:if>
</xsl:template>

<!-- html5 uses <ul> instead of <dl> for toc -->
<xsl:template name="process.qanda.toc">
  <ul>
    <xsl:apply-templates select="d:qandadiv" mode="qandatoc.mode"/>
    <xsl:apply-templates select="d:qandaset|d:qandaentry" mode="qandatoc.mode"/>
  </ul>
</xsl:template>

<xsl:template match="d:qandadiv" mode="qandatoc.mode">
  <!--
  <dt><xsl:apply-templates select="d:title" mode="qandatoc.mode"/></dt>
  <dd><xsl:call-template name="process.qanda.toc"/></dd>
  -->
  <li>
    <xsl:apply-templates select="d:title" mode="qandatoc.mode"/>
    <xsl:call-template name="process.qanda.toc"/>
  </li>
</xsl:template>

<!-- output html5 video and source elements -->
<xsl:template match="d:videoobject">
  <video>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="video.poster"/>
    <!-- copy videodata attributes from first videodata child only -->
    <xsl:apply-templates select="d:videodata[1]/@*" mode="video.attribute"/>
    <xsl:apply-templates select="d:videodata[1]/d:multimediaparam" mode="video.attribute"/>

    <!-- generate <source> element for each videodata element -->
    <xsl:apply-templates select="d:videodata"/>

    <!-- add any fallback content -->
    <xsl:call-template name="video.fallback"/>

  </video>
</xsl:template>

<!-- output html5 audio and source elements -->
<xsl:template match="d:audioobject">
  <audio>
    <xsl:call-template name="common.html.attributes"/>

    <!-- copy audiodata attributes from first audiodata child only -->
    <xsl:apply-templates select="d:audiodata[1]/@*" mode="audio.attribute"/>
    <xsl:apply-templates select="d:audiodata[1]/d:multimediaparam" mode="audio.attribute"/>

    <!-- generate <source> element for each videodata element -->
    <xsl:apply-templates select="d:audiodata"/>

    <!-- add any fallback content -->
    <xsl:call-template name="audio.fallback"/>

  </audio>
</xsl:template>

<xsl:template match="d:videodata">

  <xsl:variable name="filename">
    <xsl:call-template name="mediaobject.filename">
      <!-- Call it with the videodata as the object -->
      <xsl:with-param name="object" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <source>
    <xsl:call-template name="common.html.attributes"/>

    <xsl:attribute name="src">
      <xsl:value-of select="$filename"/>
    </xsl:attribute>

    <xsl:apply-templates select="@format" mode="source.attribute"/>

    <xsl:apply-templates select="d:multimediaparam" mode="source.attribute"/>
    
  </source>
</xsl:template>

<xsl:template match="d:audiodata">

  <xsl:variable name="filename">
    <xsl:call-template name="mediaobject.filename">
      <!-- Call it with the videodata as the object -->
      <xsl:with-param name="object" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <source>
    <xsl:call-template name="common.html.attributes"/>

    <xsl:attribute name="src">
      <xsl:value-of select="$filename"/>
    </xsl:attribute>

    <xsl:apply-templates select="@format" mode="source.attribute"/>

    <xsl:apply-templates select="d:multimediaparam" mode="source.attribute"/>
    
  </source>
</xsl:template>

<!-- attributes handled in modes, so default is off -->
<xsl:template match="@*" mode="source.attribute"/>
<xsl:template match="@*" mode="video.attribute"/>
<xsl:template match="@*" mode="audio.attribute"/>

<xsl:template match="@format" mode="source.attribute">
  <xsl:attribute name="type">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:attribute>
</xsl:template>

<!-- use only an imageobject with @role = 'poster' -->
<xsl:template name="video.poster">
  <!-- context is videoobject -->
  <xsl:variable name="imageobject" 
                select="../../d:imageobject[@role = 'poster'][1] |
                           ../d:imageobject[@role = 'poster'][1]"/>
  <xsl:if test="$imageobject">
    <xsl:attribute name="poster">
      <xsl:value-of select="$imageobject/d:imagedata/@fileref"/>
    </xsl:attribute> 
  </xsl:if>
</xsl:template>

<xsl:template match="d:videodata/@fileref" mode="source.attribute">
  <!-- process in normal mode -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:videodata/@fileref" mode="video.attribute"/>

<xsl:template match="d:audiodata/@fileref" mode="source.attribute">
  <!-- process in normal mode -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:audiodata/@fileref" mode="audio.attribute"/>

<xsl:template match="d:videodata/@contentwidth | d:videodata/@width"
              mode="video.attribute">
  <xsl:attribute name="width">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="d:videodata/@contentdepth | d:videodata/@depth"
              mode="video.attribute">
  <xsl:attribute name="height">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="d:multimediaparam" mode="source.attribute"/>
<xsl:template match="d:multimediaparam" mode="video.attribute"/>

<xsl:template match="d:multimediaparam[@name = 'autoplay' or
                                       @name = 'controls' or
                                       @name = 'height' or
                                       @name = 'loop' or
                                       @name = 'muted' or
                                       @name = 'preload' or
                                       @name = 'width']"
             mode="video.attribute">
  <xsl:call-template name="process.multimediaparam">
    <xsl:with-param name="object" select=".."/>
    <xsl:with-param name="param.name" select="@name"/>
    <xsl:with-param name="param.value" select="@value"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:multimediaparam[@name = 'autoplay' or
                                       @name = 'controls' or
                                       @name = 'loop' or
                                       @name = 'muted' or
                                       @name = 'preload']"
             mode="audio.attribute">
  <xsl:call-template name="process.multimediaparam">
    <xsl:with-param name="object" select=".."/>
    <xsl:with-param name="param.name" select="@name"/>
    <xsl:with-param name="param.value" select="@value"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:multimediaparam[not(@name = 'autoplay' or
                                       @name = 'controls' or
                                       @name = 'height' or
                                       @name = 'loop' or
                                       @name = 'muted' or
                                       @name = 'preload' or
                                       @name = 'width')]"
             mode="source.attribute">
  <xsl:call-template name="process.multimediaparam">
    <xsl:with-param name="object" select=".."/>
    <xsl:with-param name="param.name" select="@name"/>
    <xsl:with-param name="param.value" select="@value"/>
  </xsl:call-template>
</xsl:template>


<!-- Determines the best value of a media attribute from the
  attributes and multimediaparam elements -->
<xsl:template name="process.multimediaparam">
  <xsl:param name="object" select="NOTANELEMENT"/>
  <xsl:param name="param.name"/>
  <xsl:param name="param.value"/>

  <xsl:choose>
    <xsl:when test="$object/*/@*[local-name(.) = $param.name]">
      <!-- explicit attribute with that name takes precedence -->
      <xsl:attribute name="{$param.name}">
        <xsl:value-of select="$object/*/@*[local-name(.) = $param.name]"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="{$param.name}">
        <xsl:value-of select="$param.value"/>
      </xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="video.fallback">
  <xsl:param name="videoobject" select="."/>
  <xsl:variable name="textobject" select="$videoobject/../d:textobject"/>

  <xsl:choose>
    <xsl:when test="$textobject">
      <xsl:apply-templates select="$textobject" mode="fallback"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="video.fallback.text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="video.fallback.text">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'video-unsupported'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="audio.fallback">
  <xsl:param name="audiodata" select="."/>
  <xsl:variable name="textobject" select="$audiodata/../../d:textobject"/>

  <xsl:choose>
    <xsl:when test="$textobject">
      <xsl:apply-templates select="$textobject" mode="fallback"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="audio.fallback.text"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="audio.fallback.text">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'audio-unsupported'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:textobject" mode="fallback">
  <div>
    <xsl:apply-templates select="." mode="class.attribute"/>
    <xsl:apply-templates/>
  </div> 
</xsl:template>

<!-- HTML5: no body attributes -->
<xsl:template name="body.attributes"/>

</xsl:stylesheet>

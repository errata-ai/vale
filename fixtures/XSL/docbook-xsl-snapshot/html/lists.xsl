<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:itemizedlist">
  <!-- Handle spacing="compact" as multiple class attribute instead
       of the deprecated HTML compact attribute -->
  <xsl:variable name="default.class">
    <xsl:value-of select="local-name()"/>
    <xsl:if test="@spacing = 'compact'">
      <xsl:text> compact</xsl:text>
    </xsl:if>
  </xsl:variable>
  
  <xsl:variable name="style.value">
    <xsl:variable name="type">
      <xsl:call-template name="list.itemsymbol"/>
    </xsl:variable>

    <xsl:text>list-style-type: </xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text>; </xsl:text>
  </xsl:variable>

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="d:title|d:info/d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <!-- Preserve order of PIs and comments -->
    <xsl:apply-templates 
        select="*[not(self::d:listitem
                  or self::d:title
                  or self::d:titleabbrev)]
                |comment()[not(preceding-sibling::d:listitem)]
                |processing-instruction()[not(preceding-sibling::d:listitem)]"/>

    <ul>
      <xsl:call-template name="generate.class.attribute">
        <xsl:with-param name="class" select="$default.class"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$css.decoration != 0">
          <xsl:attribute name="style">
            <xsl:value-of select="$style.value"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$make.clean.html != 0">
          <!-- styled by separate css only -->
        </xsl:when>
        <xsl:otherwise>
          <!-- use the old @type attribute -->
          <xsl:attribute name="type">
            <xsl:call-template name="list.itemsymbol"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates 
            select="d:listitem
                    |comment()[preceding-sibling::d:listitem]
                    |processing-instruction()[preceding-sibling::d:listitem]"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="d:itemizedlist/d:title">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:itemizedlist/d:listitem">
  <xsl:variable name="mark" select="../@mark"/>
  <xsl:variable name="override" select="@override"/>

  <xsl:variable name="usemark">
    <xsl:choose>
      <xsl:when test="$override != ''">
        <xsl:value-of select="$override"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$mark"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cssmark">
    <xsl:choose>
      <xsl:when test="$usemark = 'opencircle'">circle</xsl:when>
      <xsl:when test="$usemark = 'bullet'">disc</xsl:when>
      <xsl:when test="$usemark = 'box'">square</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$usemark"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <li>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="$css.decoration = '1' and $cssmark != ''">
      <xsl:attribute name="style">
        <xsl:text>list-style-type: </xsl:text>
        <xsl:value-of select="$cssmark"/>
      </xsl:attribute>
    </xsl:if>

    <!-- we can't just drop the anchor in since some browsers (Opera)
         get confused about line breaks if we do. So if the first child
         is a para, assume the para will put in the anchor. Otherwise,
         put the anchor in anyway. -->
    <xsl:if test="local-name(child::*[1]) != 'para'">
      <xsl:call-template name="anchor"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
        <div class="{@revisionflag}">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

<xsl:template match="d:orderedlist">
  <!-- Handle spacing="compact" as multiple class attribute instead
       of the deprecated HTML compact attribute -->
  <xsl:variable name="default.class">
    <xsl:value-of select="local-name()"/>
    <xsl:if test="@spacing = 'compact'">
      <xsl:text> compact</xsl:text>
    </xsl:if>
  </xsl:variable>
  
  <xsl:variable name="start">
    <xsl:call-template name="orderedlist-starting-number"/>
  </xsl:variable>

  <xsl:variable name="numeration">
    <xsl:call-template name="list.numeration"/>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$numeration='arabic'">1</xsl:when>
      <xsl:when test="$numeration='loweralpha'">a</xsl:when>
      <xsl:when test="$numeration='lowerroman'">i</xsl:when>
      <xsl:when test="$numeration='upperalpha'">A</xsl:when>
      <xsl:when test="$numeration='upperroman'">I</xsl:when>
      <!-- What!? This should never happen -->
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unexpected numeration: </xsl:text>
          <xsl:value-of select="$numeration"/>
        </xsl:message>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>

    <xsl:if test="d:title|d:info/d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <!-- Preserve order of PIs and comments -->
    <xsl:apply-templates 
        select="*[not(self::d:listitem
                  or self::d:title
                  or self::d:titleabbrev)]
                |comment()[not(preceding-sibling::d:listitem)]
                |processing-instruction()[not(preceding-sibling::d:listitem)]"/>

    <xsl:choose>
      <xsl:when test="@inheritnum='inherit' and ancestor::d:listitem[parent::d:orderedlist]">
        <table border="{$table.border.off}">
          <xsl:call-template name="generate.class.attribute">
            <xsl:with-param name="class" select="$default.class"/>
          </xsl:call-template>
          <colgroup>
            <col align="{$direction.align.start}" valign="top"/>
            <col/>
          </colgroup>
          <tbody>
            <xsl:apply-templates 
                mode="orderedlist-table"
                select="d:listitem
                        |comment()[preceding-sibling::d:listitem]
                        |processing-instruction()[preceding-sibling::d:listitem]"/>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <ol>
          <xsl:call-template name="generate.class.attribute">
            <xsl:with-param name="class" select="$default.class"/>
          </xsl:call-template>
          <xsl:if test="$start != '1'">
            <xsl:attribute name="start">
              <xsl:value-of select="$start"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$numeration != ''">
            <xsl:attribute name="type">
              <xsl:value-of select="$type"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates 
                select="d:listitem
                        |comment()[preceding-sibling::d:listitem]
                        |processing-instruction()[preceding-sibling::d:listitem]"/>
        </ol>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="d:orderedlist/d:title">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:orderedlist/d:listitem">
  <li>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="@override">
      <xsl:attribute name="value">
        <xsl:value-of select="@override"/>
      </xsl:attribute>
    </xsl:if>

    <!-- we can't just drop the anchor in since some browsers (Opera)
         get confused about line breaks if we do. So if the first child
         is a para, assume the para will put in the anchor. Otherwise,
         put the anchor in anyway. -->
    <xsl:if test="local-name(child::*[1]) != 'para'">
      <xsl:call-template name="anchor"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
        <div class="{@revisionflag}">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

<xsl:template match="d:orderedlist/d:listitem" mode="orderedlist-table">
  <tr>
    <td>
      <xsl:apply-templates select="." mode="item-number"/>
    </td>
    <td>
      <xsl:if test="local-name(child::*[1]) != 'para'">
        <xsl:call-template name="id.attribute"/>
        <xsl:call-template name="anchor"/>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$show.revisionflag != 0 and @revisionflag">
          <div class="{@revisionflag}">
            <xsl:apply-templates/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>

<xsl:template match="d:variablelist">
  <xsl:variable name="pi-presentation">
    <xsl:call-template name="pi.dbhtml_list-presentation"/>
  </xsl:variable>
  <!-- Handle spacing="compact" as multiple class attribute instead
       of the deprecated HTML compact attribute -->
  <xsl:variable name="default.class">
    <xsl:value-of select="local-name()"/>
    <xsl:if test="@spacing = 'compact'">
      <xsl:text> compact</xsl:text>
    </xsl:if>
  </xsl:variable>
  

  <xsl:variable name="presentation">
    <xsl:choose>
      <xsl:when test="$pi-presentation != ''">
        <xsl:value-of select="$pi-presentation"/>
      </xsl:when>
      <xsl:when test="$variablelist.as.table != 0">
        <xsl:value-of select="'table'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'list'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="list-width">
    <xsl:call-template name="pi.dbhtml_list-width"/>
  </xsl:variable>

  <xsl:variable name="term-width">
    <xsl:call-template name="pi.dbhtml_term-width"/>
  </xsl:variable>

  <xsl:variable name="table-summary">
    <xsl:call-template name="pi.dbhtml_table-summary"/>
  </xsl:variable>

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="d:title|d:info/d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$presentation = 'table'">
        <!-- Preserve order of PIs and comments -->
        <xsl:apply-templates 
          select="*[not(self::d:varlistentry
                    or self::d:title
                    or self::d:titleabbrev)]
                  |comment()[not(preceding-sibling::d:varlistentry)]
                  |processing-instruction()[not(preceding-sibling::d:varlistentry)]"/>
        <table border="{$table.border.off}">
          <xsl:call-template name="generate.class.attribute">
            <xsl:with-param name="class" select="$default.class"/>
          </xsl:call-template>
          <xsl:if test="$list-width != ''">
            <xsl:attribute name="width">
              <xsl:value-of select="$list-width"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$table-summary != ''">
            <xsl:attribute name="summary">
              <xsl:value-of select="$table-summary"/>
            </xsl:attribute>
          </xsl:if>
          <colgroup>
            <col align="{$direction.align.start}" valign="top">
              <xsl:if test="$term-width != ''">
                <xsl:attribute name="width">
                  <xsl:value-of select="$term-width"/>
                </xsl:attribute>
              </xsl:if>
            </col>
            <col/>
          </colgroup>
          <tbody>
            <xsl:apply-templates mode="varlist-table"
              select="d:varlistentry
                      |comment()[preceding-sibling::d:varlistentry]
                      |processing-instruction()[preceding-sibling::d:varlistentry]"/>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <!-- Preserve order of PIs and comments -->
        <xsl:apply-templates 
          select="*[not(self::d:varlistentry
                    or self::d:title
                    or self::d:titleabbrev)]
                  |comment()[not(preceding-sibling::d:varlistentry)]
                  |processing-instruction()[not(preceding-sibling::d:varlistentry)]"/>
        <dl>
          <xsl:call-template name="generate.class.attribute">
            <xsl:with-param name="class" select="$default.class"/>
          </xsl:call-template>
          <xsl:apply-templates 
              select="d:varlistentry
                      |comment()[preceding-sibling::d:varlistentry]
                      |processing-instruction()[preceding-sibling::d:varlistentry]"/>
        </dl>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="d:variablelist/d:title">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:itemizedlist/d:titleabbrev|d:orderedlist/d:titleabbrev">
  <!--nop-->
</xsl:template>

<xsl:template match="d:variablelist/d:titleabbrev">
  <!--nop-->
</xsl:template>

<xsl:template match="d:listitem" mode="xref">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="d:listitem/d:simpara" priority="2">
  <!-- If a listitem contains only a single simpara, don't output
       the <p> wrapper; this has the effect of creating an li
       with simple text content. -->
  <xsl:choose>
    <xsl:when test="not(preceding-sibling::*)
                    and not (following-sibling::*)">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:call-template name="id.attribute"/>
        <xsl:choose>
          <xsl:when test="@role and $para.propagates.style != 0">
            <xsl:call-template name="common.html.attributes">
              <xsl:with-param name="class" select="@role"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="common.html.attributes"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="anchor"/>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:varlistentry">
  <dt>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates select="d:term"/>
  </dt>
  <dd>
    <xsl:apply-templates select="d:listitem"/>
  </dd>
</xsl:template>

<xsl:template match="d:varlistentry" mode="varlist-table">
  <xsl:variable name="presentation">
    <xsl:call-template name="pi.dbhtml_term-presentation">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="separator">
    <xsl:call-template name="pi.dbhtml_term-separator">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>
  <tr>
    <xsl:call-template name="tr.attributes">
      <xsl:with-param name="rownum">
        <xsl:number from="d:variablelist" count="d:varlistentry"/>
      </xsl:with-param>
    </xsl:call-template>

    <td>
      <xsl:call-template name="id.attribute"/>
      <p>
      <xsl:call-template name="anchor"/>
      <xsl:choose>
        <xsl:when test="$presentation = 'bold'">
          <strong>
            <xsl:apply-templates select="d:term"/>
            <xsl:value-of select="$separator"/>
          </strong>
        </xsl:when>
        <xsl:when test="$presentation = 'italic'">
          <em>
            <xsl:apply-templates select="d:term"/>
            <xsl:value-of select="$separator"/>
          </em>
        </xsl:when>
        <xsl:when test="$presentation = 'bold-italic'">
          <strong>
            <em>
              <xsl:apply-templates select="d:term"/>
              <xsl:value-of select="$separator"/>
            </em>
          </strong>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="d:term"/>
          <xsl:value-of select="$separator"/>
        </xsl:otherwise>
      </xsl:choose>
      </p>
    </td>
    <td>
      <xsl:apply-templates select="d:listitem"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="d:varlistentry/d:term">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * if we have multiple terms in the same varlistentry, generate -->
        <!-- * a separator (", " by default) and/or an additional line -->
        <!-- * break after each one except the last -->
        <xsl:value-of select="$variablelist.term.separator"/>
        <xsl:if test="not($variablelist.term.break.after = '0')">
          <br/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="d:varlistentry/d:listitem">
  <!-- we can't just drop the anchor in since some browsers (Opera)
       get confused about line breaks if we do. So if the first child
       is a para, assume the para will put in the anchor. Otherwise,
       put the anchor in anyway. -->
  <xsl:if test="local-name(child::*[1]) != 'para'">
    <xsl:call-template name="anchor"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$show.revisionflag != 0 and @revisionflag">
      <div class="{@revisionflag}">
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:simplelist">
  <!-- with no type specified, the default is 'vert' -->
  <xsl:call-template name="anchor"/>
  <table border="{$table.border.off}">
    <xsl:if test="$div.element != 'section'">
      <xsl:attribute name="summary">Simple list</xsl:attribute>
    </xsl:if>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="simplelist.vert">
      <xsl:with-param name="cols">
        <xsl:choose>
          <xsl:when test="@columns">
            <xsl:value-of select="@columns"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template match="d:simplelist[@type='inline']">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <!-- if dbchoice PI exists, use that to determine the choice separator -->
    <!-- (that is, equivalent of "and" or "or" in current locale), or literal -->
    <!-- value of "choice" otherwise -->
    <xsl:variable name="localized-choice-separator">
      <xsl:choose>
        <xsl:when test="processing-instruction('dbchoice')">
          <xsl:call-template name="select.choice.separator"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- empty -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <xsl:for-each select="d:member">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:apply-templates/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="position() = last()"/> <!-- do nothing -->
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
          <xsl:if test="position() = last() - 1">
            <xsl:if test="$localized-choice-separator != ''">
              <xsl:value-of select="$localized-choice-separator"/>
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </span>
</xsl:template>

<xsl:template match="d:simplelist[@type='horiz']">
  <xsl:call-template name="anchor"/>
  <table border="{$table.border.off}">
    <xsl:if test="$div.element != 'section'">
      <xsl:attribute name="summary">Simple list</xsl:attribute>
    </xsl:if>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="simplelist.horiz">
      <xsl:with-param name="cols">
        <xsl:choose>
          <xsl:when test="@columns">
            <xsl:value-of select="@columns"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template match="d:simplelist[@type='vert']">
  <xsl:call-template name="anchor"/>
  <table border="{$table.border.off}">
    <xsl:if test="$div.element != 'section'">
      <xsl:attribute name="summary">Simple list</xsl:attribute>
    </xsl:if>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="simplelist.vert">
      <xsl:with-param name="cols">
        <xsl:choose>
          <xsl:when test="@columns">
            <xsl:value-of select="@columns"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template name="simplelist.horiz">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./d:member"/>

  <xsl:if test="$cell &lt;= count($members)">
    <tr>
      <xsl:call-template name="tr.attributes">
        <xsl:with-param name="row" select="$members[1]"/>
        <xsl:with-param name="rownum" select="(($cell - 1) div $cols) + 1"/>
      </xsl:call-template>

      <xsl:call-template name="simplelist.horiz.row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
   </tr>
    <xsl:call-template name="simplelist.horiz">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell + $cols"/>
      <xsl:with-param name="members" select="$members"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="simplelist.horiz.row">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./d:member"/>
  <xsl:param name="curcol">1</xsl:param>

  <xsl:if test="$curcol &lt;= $cols">
    <td>
      <xsl:choose>
        <xsl:when test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:call-template name="simplelist.horiz.row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="simplelist.vert">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./d:member"/>
  <xsl:param name="rows"
             select="floor((count($members)+$cols - 1) div $cols)"/>

  <xsl:if test="$cell &lt;= $rows">
    <tr>
      <xsl:call-template name="tr.attributes">
        <xsl:with-param name="row" select="$members[1]"/>
        <xsl:with-param name="rownum" select="$cell"/>
      </xsl:call-template>

      <xsl:call-template name="simplelist.vert.row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
    </tr>
    <xsl:call-template name="simplelist.vert">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="simplelist.vert.row">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="rows">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./d:member"/>
  <xsl:param name="curcol">1</xsl:param>

  <xsl:if test="$curcol &lt;= $cols">
    <td>
      <xsl:choose>
        <xsl:when test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:call-template name="simplelist.vert.row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="$rows"/>
      <xsl:with-param name="cell" select="$cell+$rows"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="d:member">
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="simple.xlink">
    <xsl:with-param name="content">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:procedure">
  <xsl:variable name="param.placement"
                select="substring-after(normalize-space($formal.title.placement),
                                        concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Preserve order of PIs and comments -->
  <xsl:variable name="preamble"
        select="*[not(self::d:step
                  or self::d:title
                  or self::d:titleabbrev)]
                |comment()[not(preceding-sibling::d:step)]
                |processing-instruction()[not(preceding-sibling::d:step)]"/>

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional">
        <xsl:choose>
          <xsl:when test="d:title">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional">
        <xsl:choose>
          <xsl:when test="d:title|d:info/d:title|d:blockinfo/d:title">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:if test="(d:title or d:info/d:title or d:blockinfo/d:title) and $placement = 'before'">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <xsl:apply-templates select="$preamble"/>

    <xsl:choose>
      <xsl:when test="count(d:step) = 1">
        <ul>
          <xsl:call-template name="generate.class.attribute"/>
          <xsl:apply-templates 
            select="d:step
                    |comment()[preceding-sibling::d:step]
                    |processing-instruction()[preceding-sibling::d:step]"/>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <ol>
          <xsl:call-template name="generate.class.attribute"/>
          <xsl:attribute name="type">
            <xsl:value-of select="substring($procedure.step.numeration.formats,1,1)"/>
          </xsl:attribute>
          <xsl:apply-templates 
            select="d:step
                    |comment()[preceding-sibling::d:step]
                    |processing-instruction()[preceding-sibling::d:step]"/>
        </ol>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="(d:title or d:info/d:title or d:blockinfo/d:title) and $placement != 'before'">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="d:procedure/d:title">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:substeps">
  <xsl:variable name="numeration">
    <xsl:call-template name="procedure.step.numeration"/>
  </xsl:variable>

  <xsl:call-template name="anchor"/>

  <ol type="{$numeration}">
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="d:step">
  <li>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="d:stepalternatives">
  <xsl:call-template name="anchor"/>
  <ul>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="d:step/d:title">
  <p>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:choose>
      <xsl:when test="$make.clean.html != 0">
	<span class="step-title">
	  <xsl:apply-templates/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<b>
	  <xsl:apply-templates/>
	</b>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:segmentedlist">
  <xsl:variable name="presentation">
    <xsl:call-template name="pi.dbhtml_list-presentation"/>
  </xsl:variable>

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>

    <xsl:choose>
      <xsl:when test="$presentation = 'table'">
        <xsl:apply-templates select="." mode="seglist-table"/>
      </xsl:when>
      <xsl:when test="$presentation = 'list'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$segmentedlist.as.table != 0">
        <xsl:apply-templates select="." mode="seglist-table"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="d:segmentedlist/d:title">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <strong>
      <span>
        <xsl:call-template name="generate.class.attribute"/>
        <xsl:apply-templates/>
      </span>
    </strong>
  </div>
</xsl:template>

<xsl:template match="d:segtitle">
</xsl:template>

<xsl:template match="d:segtitle" mode="segtitle-in-seg">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:seglistitem">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:seg">
  <xsl:variable name="segnum" select="count(preceding-sibling::d:seg)+1"/>
  <xsl:variable name="seglist" select="ancestor::d:segmentedlist"/>
  <xsl:variable name="segtitles" select="$seglist/d:segtitle"/>

  <!--
     Note: segtitle is only going to be the right thing in a well formed
     SegmentedList.  If there are too many Segs or too few SegTitles,
     you'll get something odd...maybe an error
  -->

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <strong>
      <span class="segtitle">
        <xsl:apply-templates select="$segtitles[$segnum=position()]"
                             mode="segtitle-in-seg"/>
        <xsl:text>: </xsl:text>
      </span>
    </strong>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:segmentedlist" mode="seglist-table">
  <xsl:variable name="table-summary">
    <xsl:call-template name="pi.dbhtml_table-summary"/>
  </xsl:variable>

  <xsl:variable name="list-width">
    <xsl:call-template name="pi.dbhtml_list-width"/>
  </xsl:variable>

  <xsl:apply-templates select="d:title"/>

  <table border="{$table.border.off}">
    <xsl:if test="$list-width != ''">
      <xsl:attribute name="width">
        <xsl:value-of select="$list-width"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$table-summary != '' and $div.element != 'section'">
      <xsl:attribute name="summary">
        <xsl:value-of select="$table-summary"/>
      </xsl:attribute>
    </xsl:if>
    <thead>
      <tr class="segtitle">
        <xsl:call-template name="tr.attributes">
          <xsl:with-param name="row" select="d:segtitle[1]"/>
          <xsl:with-param name="rownum" select="1"/>
        </xsl:call-template>
        <xsl:apply-templates select="d:segtitle" mode="seglist-table"/>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates select="d:seglistitem" mode="seglist-table"/>
    </tbody>
  </table>
</xsl:template>

<xsl:template match="d:segtitle" mode="seglist-table">
  <th><xsl:apply-templates/></th>
</xsl:template>

<xsl:template match="d:seglistitem" mode="seglist-table">
  <xsl:variable name="seglinum">
    <xsl:number from="d:segmentedlist" count="d:seglistitem"/>
  </xsl:variable>

  <tr>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="tr.attributes">
      <xsl:with-param name="rownum" select="$seglinum + 1"/>
    </xsl:call-template>
    <xsl:apply-templates mode="seglist-table"/>
  </tr>
</xsl:template>

<xsl:template match="d:seg" mode="seglist-table">
  <td>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </td>
</xsl:template>

<xsl:template match="d:seg[1]" mode="seglist-table">
  <td>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="ancestor::d:seglistitem"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </td>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:calloutlist">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="d:title|d:info/d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <!-- Preserve order of PIs and comments -->
    <xsl:apply-templates 
         select="*[not(self::d:callout or self::d:title or self::d:titleabbrev)]
                   |comment()[not(preceding-sibling::d:callout)]
                   |processing-instruction()[not(preceding-sibling::d:callout)]"/>

    <xsl:choose>
      <xsl:when test="$callout.list.table != 0">
        <table border="{$table.border.off}">
          <xsl:if test="$div.element != 'section'">
            <xsl:attribute name="summary">Callout list</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="d:callout
                                |comment()[preceding-sibling::d:callout]
                                |processing-instruction()[preceding-sibling::d:callout]"/>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <dl>
          <xsl:apply-templates select="." mode="class.attribute"/>
          <xsl:apply-templates select="d:callout
                                |comment()[preceding-sibling::d:callout]
                                |processing-instruction()[preceding-sibling::d:callout]"/>
        </dl>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="d:calloutlist/d:title">
</xsl:template>

<xsl:template match="d:callout">
  <xsl:choose>
    <xsl:when test="$callout.list.table != 0">
      <tr>
        <xsl:call-template name="tr.attributes">
          <xsl:with-param name="rownum">
            <xsl:number from="d:calloutlist" count="d:callout"/>
          </xsl:with-param>
        </xsl:call-template>

        <td width="5%" valign="top" align="{$direction.align.start}">
          <xsl:call-template name="id.attribute"/>
          <p>
            <xsl:call-template name="anchor"/>
            <xsl:call-template name="callout.arearefs">
              <xsl:with-param name="arearefs" select="@arearefs"/>
            </xsl:call-template>
          </p>
        </td>
        <td valign="top" align="{$direction.align.start}">
          <xsl:apply-templates/>
        </td>
      </tr>
    </xsl:when>
    <xsl:otherwise>
      <dt>
        <xsl:call-template name="id.attribute"/>
        <xsl:call-template name="anchor"/>
        <xsl:call-template name="callout.arearefs">
          <xsl:with-param name="arearefs" select="@arearefs"/>
        </xsl:call-template>
      </dt>
      <dd><xsl:apply-templates/></dd>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:callout/d:simpara" priority="2">
  <!-- If a callout contains only a single simpara, don't output
       the <p> wrapper; this has the effect of creating an li
       with simple text content. -->
  <xsl:choose>
    <xsl:when test="not(preceding-sibling::*)
                    and not (following-sibling::*)">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:call-template name="id.attribute"/>
        <xsl:if test="@role and $para.propagates.style != 0">
          <xsl:choose>
            <xsl:when test="@role and $para.propagates.style != 0">
              <xsl:call-template name="common.html.attributes">
                <xsl:with-param name="class" select="@role"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="common.html.attributes"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:call-template name="anchor"/>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="callout.arearefs">
  <xsl:param name="arearefs"></xsl:param>
  <xsl:if test="$arearefs!=''">
    <xsl:choose>
      <xsl:when test="substring-before($arearefs,' ')=''">
        <xsl:call-template name="callout.arearef">
          <xsl:with-param name="arearef" select="$arearefs"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="callout.arearef">
          <xsl:with-param name="arearef"
                          select="substring-before($arearefs,' ')"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="callout.arearefs">
      <xsl:with-param name="arearefs"
                      select="substring-after($arearefs,' ')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="callout.arearef">
  <xsl:param name="arearef"></xsl:param>
  <xsl:variable name="targets" select="key('id',$arearef)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:call-template name="check.id.unique">
    <xsl:with-param name="linkend" select="$arearef"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="count($target)=0">
      <xsl:text>???</xsl:text>
    </xsl:when>
    <xsl:when test="local-name($target)='co'">
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="$arearef"/>
        </xsl:attribute>
        <xsl:apply-templates select="$target" mode="callout-bug"/>
      </a>
      <xsl:text> </xsl:text>
    </xsl:when>
    <xsl:when test="local-name($target)='areaset'">
      <xsl:call-template name="callout-bug">
        <xsl:with-param name="conum">
          <xsl:apply-templates select="$target" mode="conumber"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($target)='area'">
      <xsl:choose>
        <xsl:when test="$target/parent::d:areaset">
          <xsl:call-template name="callout-bug">
            <xsl:with-param name="conum">
              <xsl:apply-templates select="$target/parent::d:areaset"
                                   mode="conumber"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="callout-bug">
            <xsl:with-param name="conum">
              <xsl:apply-templates select="$target" mode="conumber"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>???</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="orderedlist-starting-number">
  <xsl:param name="list" select="."/>
  <xsl:variable name="pi-start">
    <xsl:call-template name="pi.dbhtml_start">
      <xsl:with-param name="node" select="$list"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="output-orderedlist-starting-number">
    <xsl:with-param name="list" select="$list"/>
    <xsl:with-param name="pi-start" select="$pi-start"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

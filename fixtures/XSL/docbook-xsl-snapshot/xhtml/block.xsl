<?xml version="1.0" encoding="ASCII"?><!--This file was created automatically by html2xhtml--><!--from the HTML stylesheets.--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="d" version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- What should we do about styling blockinfo? -->

<xsl:template match="d:blockinfo|d:info">
  <!-- suppress -->
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="block.object">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:para">
  <xsl:call-template name="paragraph">
    <xsl:with-param name="class">
      <xsl:if test="@role and $para.propagates.style != 0">
        <xsl:value-of select="@role"/>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="content">
      <xsl:if test="position() = 1 and parent::d:listitem">
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="parent::d:listitem"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="paragraph">
  <xsl:param name="class" select="''"/>
  <xsl:param name="content"/>

  <xsl:variable name="p">
    <p>
      <xsl:call-template name="id.attribute"/>
      <xsl:choose>
        <xsl:when test="$class != ''">
          <xsl:call-template name="common.html.attributes">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="common.html.attributes">
            <xsl:with-param name="class" select="''"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:copy-of select="$content"/>
    </p>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$html.cleanup != 0">
      <xsl:call-template name="unwrap.p">
        <xsl:with-param name="p" select="$p"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$p"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:simpara">
  <!-- see also listitem/simpara in lists.xsl -->
  <p>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="locale.html.attributes"/>
    <xsl:if test="@role and $para.propagates.style != 0">
      <xsl:apply-templates select="." mode="class.attribute">
        <xsl:with-param name="class" select="@role"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="d:formalpara">
  <xsl:call-template name="paragraph">
    <xsl:with-param name="class">
      <xsl:if test="@role and $para.propagates.style != 0">
        <xsl:value-of select="@role"/>
      </xsl:if>
    </xsl:with-param>
    <xsl:with-param name="content">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- Only use title from info -->
<xsl:template match="d:formalpara/d:info">
  <xsl:apply-templates select="d:title"/>
</xsl:template>

<xsl:template match="d:formalpara/d:title|d:formalpara/d:info/d:title">
  <xsl:variable name="titleStr">
      <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="lastChar">
    <xsl:if test="$titleStr != ''">
      <xsl:value-of select="substring($titleStr,string-length($titleStr),1)"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <span class="formalpara-title">
        <xsl:copy-of select="$titleStr"/>
        <xsl:if test="$lastChar != ''                       and not(contains($runinhead.title.end.punct, $lastChar))">
          <xsl:value-of select="$runinhead.default.title.end.punct"/>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <strong>
        <xsl:copy-of select="$titleStr"/>
        <xsl:if test="$lastChar != ''                       and not(contains($runinhead.title.end.punct, $lastChar))">
          <xsl:value-of select="$runinhead.default.title.end.punct"/>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
      </strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:formalpara/d:para">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:blockquote">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>

    <xsl:choose>
      <xsl:when test="d:attribution">
        <table border="{$table.border.off}" class="blockquote">
          <xsl:if test="$css.decoration != 0">
            <xsl:attribute name="style">
              <xsl:text>width: 100%; cellspacing: 0; cellpadding: 0;</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$div.element != 'section'">
            <xsl:attribute name="summary">Block quote</xsl:attribute>
          </xsl:if>
          <tr>
            <td width="10%" valign="top">&#160;</td>
            <td width="80%" valign="top">
              <xsl:apply-templates select="child::*[local-name(.)!='attribution']"/>
            </td>
            <td width="10%" valign="top">&#160;</td>
          </tr>
          <tr>
            <td width="10%" valign="top">&#160;</td>
            <td colspan="2" align="{$direction.align.end}" valign="top">
              <xsl:text>--</xsl:text>
              <xsl:apply-templates select="d:attribution"/>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <blockquote>
          <xsl:call-template name="common.html.attributes"/>
          <xsl:apply-templates/>
        </blockquote>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="d:blockquote/d:title|d:blockquote/d:info/d:title">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <div class="blockquote-title">
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="blockquote-title">
        <p>
          <strong>
            <xsl:apply-templates/>
          </strong>
        </p>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Use an em dash per Chicago Manual of Style and https://sourceforge.net/tracker/index.php?func=detail&aid=2793878&group_id=21935&atid=373747 -->
<xsl:template match="d:epigraph">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates select="child::*[local-name(.)!='attribution']"/>
    <xsl:if test="d:attribution">
      <div class="attribution">
        <span>&#8212;<xsl:apply-templates select="d:attribution"/></span>
      </div>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="d:attribution">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:sidebar">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="sidebar.titlepage"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:abstract/d:title|d:sidebar/d:title">
</xsl:template>

<xsl:template match="d:sidebar/d:sidebarinfo|d:sidebar/d:info"/>

<xsl:template match="d:abstract">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="formal.object.heading">
      <xsl:with-param name="title">
        <xsl:apply-templates select="." mode="title.markup">
          <xsl:with-param name="allow-anchors" select="'1'"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:msgset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:msgentry">
  <xsl:call-template name="block.object"/>
</xsl:template>

<xsl:template match="d:simplemsgentry">
  <xsl:call-template name="block.object"/>
</xsl:template>

<xsl:template match="d:msg">
  <xsl:call-template name="block.object"/>
</xsl:template>

<xsl:template match="d:msgmain">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:msgmain/d:title">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <span class="msgmain-title">
        <xsl:apply-templates/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <strong><xsl:apply-templates/></strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:msgsub">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:msgsub/d:title">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <span class="msgsub-title">
        <xsl:apply-templates/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <strong><xsl:apply-templates/></strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:msgrel">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:msgrel/d:title">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <span class="msgrel-title">
        <xsl:apply-templates/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <strong><xsl:apply-templates/></strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:msgtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:msginfo">
  <xsl:call-template name="block.object"/>
</xsl:template>

<xsl:template match="d:msglevel">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <div class="msglevel">
        <span class="msglevel-title">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'msgset'"/>
            <xsl:with-param name="name" select="'MsgLevel'"/>
          </xsl:call-template>
        </span>
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <strong>
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'msgset'"/>
            <xsl:with-param name="name" select="'MsgLevel'"/>
          </xsl:call-template>
        </strong>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:msgorig">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <div class="msgorig">
        <span class="msgorig-title">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'msgset'"/>
            <xsl:with-param name="name" select="'MsgOrig'"/>
          </xsl:call-template>
        </span>
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <strong>
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'msgset'"/>
            <xsl:with-param name="name" select="'MsgOrig'"/>
          </xsl:call-template>
        </strong>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:msgaud">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <div class="msgaud">
        <span class="msgaud-title">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'msgset'"/>
            <xsl:with-param name="name" select="'MsgAud'"/>
          </xsl:call-template>
        </span>
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <strong>
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'msgset'"/>
            <xsl:with-param name="name" select="'MsgAud'"/>
          </xsl:call-template>
        </strong>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:msgexplan">
  <xsl:call-template name="block.object"/>
</xsl:template>

<xsl:template match="d:msgexplan/d:title">
  <xsl:choose>
    <xsl:when test="$make.clean.html != 0">
      <div class="msgexplan">
        <span class="msgexplan-title">
          <xsl:apply-templates/>
        </span>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <strong>
          <xsl:apply-templates/>
        </strong>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:revhistory">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <table>
      <xsl:if test="$css.decoration != 0">
        <xsl:attribute name="style">
          <xsl:text>border-style:solid; width:100%;</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <!-- include summary attribute if not HTML5 -->
      <xsl:if test="$div.element != 'section'">
        <xsl:attribute name="summary">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">revhistory</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <tr>
        <th align="{$direction.align.start}" valign="top" colspan="3">
          <strong>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'RevHistory'"/>
            </xsl:call-template>
          </strong>
        </th>
      </tr>
      <xsl:apply-templates/>
    </table>
  </div>
</xsl:template>

<xsl:template match="d:revhistory/d:revision">
  <xsl:variable name="revnumber" select="d:revnumber"/>
  <xsl:variable name="revdate" select="d:date"/>
  <xsl:variable name="revauthor" select="d:authorinitials|d:author"/>
  <xsl:variable name="revremark" select="d:revremark|d:revdescription"/>
  <tr>
    <td align="{$direction.align.start}">
      <xsl:if test="$revnumber">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Revision'"/>
        </xsl:call-template>
        <xsl:call-template name="gentext.space"/>
        <xsl:apply-templates select="$revnumber"/>
      </xsl:if>
    </td>
    <td align="{$direction.align.start}">
      <xsl:apply-templates select="$revdate"/>
    </td>
    <xsl:choose>
      <xsl:when test="count($revauthor)=0">
        <td align="{$direction.align.start}">
          <xsl:call-template name="dingbat">
            <xsl:with-param name="dingbat">nbsp</xsl:with-param>
          </xsl:call-template>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td align="{$direction.align.start}">
          <xsl:for-each select="$revauthor">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </tr>
  <xsl:if test="$revremark">
    <tr>
      <td align="{$direction.align.start}" colspan="3">
        <xsl:apply-templates select="$revremark"/>
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="d:revision/d:revnumber">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:revision/d:date">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:revision/d:authorinitials">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:revision/d:authorinitials[1]" priority="2">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:revision/d:revremark">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:revision/d:revdescription">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:ackno|d:acknowledgements[parent::d:article]">
  <xsl:call-template name="block.object"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:highlights">
  <xsl:call-template name="block.object"/>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
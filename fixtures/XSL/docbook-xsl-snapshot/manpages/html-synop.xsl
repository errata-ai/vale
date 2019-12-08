<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" exclude-result-prefixes="d" version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- synopsis is in verbatim -->

<!-- ==================================================================== -->

<xsl:template match="d:cmdsynopsis">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <p>
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="..//processing-instruction('dbcmdlist')">
          <!-- * Placing a dbcmdlist PI as a child of a particular element -->
          <!-- * creates a hyperlinked list of all cmdsynopsis instances -->
          <!-- * that are descendants of that element; so for any -->
          <!-- * cmdsynopsis that is a descendant of an element containing -->
          <!-- * a dbcmdlist PI, we need to output an a@id instance so that -->
          <!-- * we will have something to link to -->
          <xsl:call-template name="anchor">
            <xsl:with-param name="conditional" select="0"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="anchor">
            <xsl:with-param name="conditional" select="1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </p>
  </div>
</xsl:template>

<xsl:template match="d:cmdsynopsis/d:command">
  <xsl:text>
.
</xsl:text>
  <xsl:call-template name="inline.monoseq"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="d:cmdsynopsis/d:command[1]" priority="2">
  <xsl:call-template name="inline.monoseq"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="d:group|d:arg" name="group-or-arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:variable name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@sepchar">
        <xsl:value-of select="ancestor-or-self::*/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="preceding-sibling::*">
    <xsl:value-of select="$sepchar"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.open.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.open.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <xsl:choose>
    <xsl:when test="$rep='repeat'">
      <xsl:value-of select="$arg.rep.repeat.str"/>
    </xsl:when>
    <xsl:when test="$rep='norepeat'">
      <xsl:value-of select="$arg.rep.norepeat.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.rep.def.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.close.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.close.str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:group/d:arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:if test="preceding-sibling::*">
    <xsl:value-of select="$arg.or.sep"/>
  </xsl:if>
  <xsl:call-template name="group-or-arg"/>
</xsl:template>

<xsl:template match="d:sbr">
  <xsl:text>
.
</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:synopfragmentref">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="synopfragment.number"/>
  </xsl:variable>
  <i>
    <a href="#{@linkend}">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$snum"/>
      <xsl:text>)</xsl:text>
    </a>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </i>
</xsl:template>

<xsl:template match="d:synopfragment" mode="synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="d:synopfragment">
  <xsl:variable name="snum">
    <xsl:apply-templates select="." mode="synopfragment.number"/>
  </xsl:variable>
  <!-- You can't introduce another <p> here, because you're 
       already in a <p> from cmdsynopsis-->
  <span>
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <a name="{$id}">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$snum"/>
      <xsl:text>)</xsl:text>
    </a>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="d:funcsynopsis">
  <xsl:if test="..//processing-instruction('dbfunclist')">
    <!-- * Placing a dbfunclist PI as a child of a particular element -->
    <!-- * creates a hyperlinked list of all funcsynopsis instances that -->
    <!-- * are descendants of that element; so for any funcsynopsis that is -->
    <!-- * a descendant of an element containing a dbfunclist PI, we need -->
    <!-- * to output an a@id instance so that we will have something to -->
    <!-- * link to -->
    <span>
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
    </span>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="d:funcsynopsisinfo">
  <xsl:text>.sp
</xsl:text><xsl:text>.nf
</xsl:text><pre>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </pre><xsl:text/><xsl:text>.fi
</xsl:text>
</xsl:template>

<!-- ====================================================================== -->
<!-- funcprototype -->
<!--

funcprototype ::= (funcdef,
                   (void|varargs|paramdef+))

funcdef       ::= (#PCDATA|type|replaceable|function)*

paramdef      ::= (#PCDATA|type|replaceable|parameter|funcparams)*
-->

<xsl:template match="d:funcprototype">
  <xsl:variable name="html-style">
    <xsl:call-template name="pi.dbhtml_funcsynopsis-style">
      <xsl:with-param name="node" select="ancestor::d:funcsynopsis/descendant-or-self::*"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="style">
    <xsl:choose>
      <xsl:when test="$html-style != ''">
        <xsl:value-of select="$html-style"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$funcsynopsis.style"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!-- * 2008-02-17. the code no longer relies on the funcsynopsis.tabular.threshold -->
<!-- * param at all (the stuff below has been commented out since mid -->
<!-- * 2006), so I completely removed the funcsynopsis.tabular.threshold param -->
<!-- * .. MikeSmith -->
<!--
  <xsl:variable name="tabular-p"
                select="$funcsynopsis.tabular.threshold &gt; 0
                        and string-length(.) &gt; $funcsynopsis.tabular.threshold"/>
-->

  <xsl:variable name="tabular-p" select="true()"/>

  <xsl:choose>
    <xsl:when test="$style = 'kr' and $tabular-p">
      <xsl:apply-templates select="." mode="kr-tabular"/>
    </xsl:when>
    <xsl:when test="$style = 'kr'">
      <xsl:apply-templates select="." mode="kr-nontabular"/>
    </xsl:when>
    <xsl:when test="$style = 'ansi' and $tabular-p">
      <xsl:apply-templates select="." mode="ansi-tabular"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="ansi-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->
<!-- funcprototype: kr, non-tabular -->

<xsl:template match="d:funcprototype" mode="kr-nontabular">
  <p>
    <xsl:apply-templates mode="kr-nontabular"/>
    <xsl:if test="d:paramdef">
      <xsl:text>
.
</xsl:text>
      <xsl:apply-templates select="d:paramdef" mode="kr-funcsynopsis-mode"/>
    </xsl:if>
  </p>
</xsl:template>

<xsl:template match="d:funcdef" mode="kr-nontabular">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="kr-nontabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="d:funcdef/d:function" mode="kr-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="kr-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="kr-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:void" mode="kr-nontabular">
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="d:varargs" mode="kr-nontabular">
  <xsl:text>...</xsl:text>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="d:paramdef" mode="kr-nontabular">
  <xsl:apply-templates select="d:parameter" mode="kr-nontabular"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <code>)</code>
      <xsl:text>;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter" mode="kr-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="kr-nontabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <code>
	<xsl:apply-templates mode="kr-nontabular"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:paramdef" mode="kr-funcsynopsis-mode">
  <xsl:if test="preceding-sibling::d:paramdef"><xsl:text>
.
</xsl:text></xsl:if>
  <code>
    <xsl:apply-templates mode="kr-funcsynopsis-mode"/>
  </code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter" mode="kr-funcsynopsis-mode">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="kr-funcsynopsis-mode"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <code>
	<xsl:apply-templates mode="kr-funcsynopsis-mode"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:funcparams" mode="kr-funcsynopsis-mode">
  <code>(</code>
  <xsl:apply-templates mode="kr-funcsynopsis-mode"/>
  <code>)</code>
</xsl:template>

<!-- ====================================================================== -->
<!-- funcprototype: kr, tabular -->

<xsl:template match="d:funcprototype" mode="kr-tabular">
  <table border="{$table.border.off}" class="funcprototype-table">
    <xsl:if test="$div.element != 'section'">
      <xsl:attribute name="summary">Function synopsis</xsl:attribute>
    </xsl:if>
    <xsl:if test="$css.decoration != 0">
      <xsl:attribute name="style">cellspacing: 0; cellpadding: 0;</xsl:attribute>
    </xsl:if>
    <tr>
      <td>
        <xsl:apply-templates select="d:funcdef" mode="kr-tabular"/>
      </td>
      <xsl:apply-templates select="(d:void|d:varargs|d:paramdef)[1]" mode="kr-tabular"/>
    </tr>
    <xsl:for-each select="(d:void|d:varargs|d:paramdef)[preceding-sibling::*[not(self::d:funcdef)]]">
      <tr>
        <td> </td>
        <xsl:apply-templates select="." mode="kr-tabular"/>
      </tr>
    </xsl:for-each>
  </table>
  <xsl:if test="d:paramdef">
    <div class="paramdef-list">
      <xsl:apply-templates select="d:paramdef" mode="kr-funcsynopsis-mode"/>
    </div>
  </xsl:if>
  <div class="funcprototype-spacer"> </div> <!-- hACk: blank div for vertical spacing -->
</xsl:template>

<xsl:template match="d:funcdef" mode="kr-tabular">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="kr-tabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="d:funcdef/d:function" mode="kr-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="kr-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="kr-tabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:void" mode="kr-tabular">
  <td>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td> </td>
</xsl:template>

<xsl:template match="d:varargs" mode="kr-tabular">
  <td>
    <xsl:text>...</xsl:text>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td> </td>
</xsl:template>

<xsl:template match="d:paramdef" mode="kr-tabular">
  <td>
    <xsl:apply-templates select="d:parameter" mode="kr-tabular"/>
    <xsl:choose>
      <xsl:when test="following-sibling::*">
	<xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<code>)</code>
	<xsl:text>;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </td>
  <td> </td>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter" mode="kr-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="kr-tabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <code>
	<xsl:apply-templates mode="kr-tabular"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:paramdef" mode="kr-tabular-funcsynopsis-mode">
  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="d:type">
	<xsl:apply-templates select="d:type" mode="kr-tabular-funcsynopsis-mode"/>
      </xsl:when>
      <xsl:when test="normalize-space(d:parameter/preceding-sibling::node()[not(self::d:parameter)]) != ''">
	<xsl:copy-of select="d:parameter/preceding-sibling::node()[not(self::d:parameter)]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <tr>
    <xsl:choose>
      <xsl:when test="$type != '' and d:funcparams">
        <td>
	  <code>
	    <xsl:copy-of select="$type"/>
	  </code>
          <xsl:text> </xsl:text>
        </td>
        <td>
	  <code>
	    <xsl:choose>
	      <xsl:when test="d:type">
		<xsl:apply-templates select="d:type/following-sibling::*" mode="kr-tabular-funcsynopsis-mode"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:apply-templates select="*" mode="kr-tabular-funcsynopsis-mode"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </code>
        </td>
      </xsl:when>

      <xsl:when test="d:funcparams">
        <td colspan="2">
	  <code>
	    <xsl:apply-templates mode="kr-tabular-funcsynopsis-mode"/>
	  </code>
        </td>
      </xsl:when>

      <xsl:otherwise>
        <td>
	  <code>
	    <xsl:apply-templates select="d:parameter/preceding-sibling::node()[not(self::d:parameter)]" mode="kr-tabular-funcsynopsis-mode"/>
	  </code>
          <xsl:text> </xsl:text>
        </td>
        <td>
	  <code>
	    <xsl:apply-templates select="d:parameter" mode="kr-tabular"/>
	    <xsl:apply-templates select="d:parameter/following-sibling::*[not(self::d:parameter)]" mode="kr-tabular-funcsynopsis-mode"/>
	    <xsl:text>;</xsl:text>
	  </code>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </tr>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter" mode="kr-tabular-funcsynopsis-mode">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="kr-tabular-funcsynopsis-mode"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <code>
	<xsl:apply-templates mode="kr-tabular-funcsynopsis-mode"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:funcparams" mode="kr-tabular-funcsynopsis-mode">
  <code>(</code>
  <xsl:apply-templates mode="kr-tabular-funcsynopsis-mode"/>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<!-- ====================================================================== -->
<!-- funcprototype: ansi, non-tabular -->

<xsl:template match="d:funcprototype" mode="ansi-nontabular">
  <p>
    <xsl:apply-templates mode="ansi-nontabular"/>
  </p>
</xsl:template>

<xsl:template match="d:funcdef" mode="ansi-nontabular">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="ansi-nontabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="d:funcdef/d:function" mode="ansi-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="ansi-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="ansi-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:void" mode="ansi-nontabular">
  <code>void)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="d:varargs" mode="ansi-nontabular">
  <xsl:text>...</xsl:text>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="d:paramdef" mode="ansi-nontabular">
  <xsl:apply-templates mode="ansi-nontabular"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <code>)</code>
      <xsl:text>;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter" mode="ansi-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="ansi-nontabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <code>
	<xsl:apply-templates mode="ansi-nontabular"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:funcparams" mode="ansi-nontabular">
  <code>(</code>
  <xsl:apply-templates mode="ansi-nontabular"/>
  <code>)</code>
</xsl:template>

<!-- ====================================================================== -->
<!-- funcprototype: ansi, tabular -->

<xsl:template match="d:funcprototype" mode="ansi-tabular">
  <table border="{$table.border.off}" class="funcprototype-table">
    <xsl:if test="$div.element != 'section'">
      <xsl:attribute name="summary">Function synopsis</xsl:attribute>
    </xsl:if>
    <xsl:if test="$css.decoration != 0">
      <xsl:attribute name="style">cellspacing: 0; cellpadding: 0;</xsl:attribute>
    </xsl:if>
    <tr>
      <td>
        <xsl:apply-templates select="d:funcdef" mode="ansi-tabular"/>
      </td>
      <xsl:apply-templates select="(d:void|d:varargs|d:paramdef)[1]" mode="ansi-tabular"/>
    </tr>
    <xsl:for-each select="(d:void|d:varargs|d:paramdef)[preceding-sibling::*[not(self::d:funcdef)]]">
      <tr>
        <td> </td>
        <xsl:apply-templates select="." mode="ansi-tabular"/>
      </tr>
    </xsl:for-each>
  </table>
  <div class="funcprototype-spacer"> </div> <!-- hACk: blank div for vertical spacing -->
</xsl:template>

<xsl:template match="d:funcdef" mode="ansi-tabular">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="ansi-tabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="d:funcdef/d:function" mode="ansi-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="ansi-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="kr-tabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:void" mode="ansi-tabular">
  <td>
    <code>void)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td> </td>
</xsl:template>

<xsl:template match="d:varargs" mode="ansi-tabular">
  <td>
    <xsl:text>...</xsl:text>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td> </td>
</xsl:template>

<xsl:template match="d:paramdef" mode="ansi-tabular">
      <td>
        <xsl:apply-templates mode="ansi-tabular"/>
        <xsl:choose>
          <xsl:when test="following-sibling::*">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <code>)</code>
            <xsl:text>;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter" mode="ansi-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="ansi-tabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <code>
	<xsl:apply-templates mode="ansi-tabular"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:funcparams" mode="ansi-tabular">
  <code>(</code>
  <xsl:apply-templates/>
  <code>)</code>
</xsl:template>

<!-- ====================================================================== -->

<xsl:variable name="default-classsynopsis-language">java</xsl:variable>

<xsl:template match="d:classsynopsis                      |d:fieldsynopsis                      |d:methodsynopsis                      |d:constructorsynopsis                      |d:destructorsynopsis">
  <xsl:param name="language">
    <xsl:choose>
      <xsl:when test="@language">
	<xsl:value-of select="@language"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$default-classsynopsis-language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$language='java' or $language='Java'">
      <xsl:apply-templates select="." mode="java"/>
    </xsl:when>
    <xsl:when test="$language='perl' or $language='Perl'">
      <xsl:apply-templates select="." mode="perl"/>
    </xsl:when>
    <xsl:when test="$language='idl' or $language='IDL'">
      <xsl:apply-templates select="." mode="idl"/>
    </xsl:when>
    <xsl:when test="$language='cpp' or $language='c++' or $language='C++'">
      <xsl:apply-templates select="." mode="cpp"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Unrecognized language on </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>: </xsl:text>
	<xsl:value-of select="$language"/>
      </xsl:message>
      <xsl:apply-templates select=".">
	<xsl:with-param name="language" select="$default-classsynopsis-language"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="synop-break">
  <xsl:if test="parent::d:classsynopsis                 or (following-sibling::d:fieldsynopsis                     |following-sibling::d:methodsynopsis                     |following-sibling::d:constructorsynopsis                     |following-sibling::d:destructorsynopsis)">
    <xsl:text>
.
</xsl:text>
  </xsl:if>
</xsl:template>


<!-- ===== Java ======================================================== -->

<xsl:template match="d:classsynopsis" mode="java">
  <xsl:text>.sp
</xsl:text><xsl:text>.nf
</xsl:text><pre>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates select="d:ooclass[1]" mode="java"/>
    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text> extends</xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="java"/>
      <xsl:if test="d:oointerface|d:ooexception">
        <xsl:text>
.
</xsl:text>
	<xsl:text>    </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:oointerface">
      <xsl:text>implements</xsl:text>
      <xsl:apply-templates select="d:oointerface" mode="java"/>
      <xsl:if test="d:ooexception">
        <xsl:text>
.
</xsl:text>
	<xsl:text>    </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:ooexception">
      <xsl:text>throws</xsl:text>
      <xsl:apply-templates select="d:ooexception" mode="java"/>
    </xsl:if>
    <xsl:text> {</xsl:text>
    <xsl:text>
.
</xsl:text>
    <xsl:apply-templates select="d:constructorsynopsis                                  |d:destructorsynopsis                                  |d:fieldsynopsis                                  |d:methodsynopsis                                  |d:classsynopsisinfo" mode="java"/>
    <xsl:text>}</xsl:text>
  </pre><xsl:text/><xsl:text>.fi
</xsl:text>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="java">
  <xsl:choose>
    <xsl:when test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
    <xsl:if test="following-sibling::*">
      <xsl:text> </xsl:text>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template match="d:classname" mode="java">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:interfacename" mode="java">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:exceptionname" mode="java">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="java">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="java"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:varname" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:initializer" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>= </xsl:text>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:void" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>void </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:methodname" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:methodparam" mode="java">
  <xsl:param name="indent">0</xsl:param>
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>,</xsl:text>
    <xsl:text>
.
</xsl:text>
    <xsl:if test="$indent &gt; 0">
      <xsl:call-template name="copy-string">
	<xsl:with-param name="string"> </xsl:with-param>
	<xsl:with-param name="count" select="$indent + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="d:parameter" mode="java">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template mode="java" match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="decl">
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$start-modifiers" mode="java"/>

    <!-- type -->
    <xsl:if test="local-name($notmod[1]) != 'methodname'">
      <xsl:apply-templates select="$notmod[1]" mode="java"/>
    </xsl:if>

    <xsl:apply-templates select="d:methodname" mode="java"/>
  </xsl:variable>

  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$decl"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="d:methodparam" mode="java">
      <xsl:with-param name="indent" select="string-length($decl)"/>
    </xsl:apply-templates>
    <xsl:text>)</xsl:text>
    <xsl:if test="d:exceptionname">
      <xsl:text>
.
</xsl:text>
      <xsl:text>    throws </xsl:text>
      <xsl:apply-templates select="d:exceptionname" mode="java"/>
    </xsl:if>
    <xsl:if test="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$end-modifiers" mode="java"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- ===== C++ ========================================================= -->

<xsl:template match="d:classsynopsis" mode="cpp">
  <xsl:text>.sp
</xsl:text><xsl:text>.nf
</xsl:text><pre>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates select="d:ooclass[1]" mode="cpp"/>
    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="cpp"/>
      <xsl:if test="d:oointerface|d:ooexception">
        <xsl:text>
.
</xsl:text>
	<xsl:text>    </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:oointerface">
      <xsl:text> implements</xsl:text>
      <xsl:apply-templates select="d:oointerface" mode="cpp"/>
      <xsl:if test="d:ooexception">
        <xsl:text>
.
</xsl:text>
	<xsl:text>    </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:ooexception">
      <xsl:text> throws</xsl:text>
      <xsl:apply-templates select="d:ooexception" mode="cpp"/>
    </xsl:if>
    <xsl:text> {</xsl:text>
    <xsl:text>
.
</xsl:text>
    <xsl:apply-templates select="d:constructorsynopsis                                  |d:destructorsynopsis                                  |d:fieldsynopsis                                  |d:methodsynopsis                                  |d:classsynopsisinfo" mode="cpp"/>
    <xsl:text>}</xsl:text>
  </pre><xsl:text/><xsl:text>.fi
</xsl:text>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="cpp">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
    <xsl:if test="following-sibling::*">
      <xsl:text> </xsl:text>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template match="d:classname" mode="cpp">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:interfacename" mode="cpp">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:exceptionname" mode="cpp">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="cpp">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:varname" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:initializer" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>= </xsl:text>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:void" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>void </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:methodname" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:methodparam" mode="cpp">
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="d:parameter" mode="cpp">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template mode="cpp" match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>

  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$start-modifiers" mode="cpp"/>

    <!-- type -->
    <xsl:if test="local-name($notmod[1]) != 'methodname'">
      <xsl:apply-templates select="$notmod[1]" mode="cpp"/>
    </xsl:if>

    <xsl:apply-templates select="d:methodname" mode="cpp"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="d:methodparam" mode="cpp"/>
    <xsl:text>)</xsl:text>
    <xsl:if test="d:exceptionname">
      <xsl:text>
.
</xsl:text>
      <xsl:text>    throws </xsl:text>
      <xsl:apply-templates select="d:exceptionname" mode="cpp"/>
    </xsl:if>
    <xsl:if test="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$end-modifiers" mode="cpp"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- ===== IDL ========================================================= -->

<xsl:template match="d:classsynopsis" mode="idl">
  <xsl:text>.sp
</xsl:text><xsl:text>.nf
</xsl:text><pre>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>interface </xsl:text>
    <xsl:apply-templates select="d:ooclass[1]" mode="idl"/>
    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="idl"/>
      <xsl:if test="d:oointerface|d:ooexception">
        <xsl:text>
.
</xsl:text>
	<xsl:text>    </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:oointerface">
      <xsl:text> implements</xsl:text>
      <xsl:apply-templates select="d:oointerface" mode="idl"/>
      <xsl:if test="d:ooexception">
        <xsl:text>
.
</xsl:text>
	<xsl:text>    </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:ooexception">
      <xsl:text> throws</xsl:text>
      <xsl:apply-templates select="d:ooexception" mode="idl"/>
    </xsl:if>
    <xsl:text> {</xsl:text>
    <xsl:text>
.
</xsl:text>
    <xsl:apply-templates select="d:constructorsynopsis                                  |d:destructorsynopsis                                  |d:fieldsynopsis                                  |d:methodsynopsis                                  |d:classsynopsisinfo" mode="idl"/>
    <xsl:text>}</xsl:text>
  </pre><xsl:text/><xsl:text>.fi
</xsl:text>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="idl">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
    <xsl:if test="following-sibling::*">
      <xsl:text> </xsl:text>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template match="d:classname" mode="idl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:interfacename" mode="idl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:exceptionname" mode="idl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="idl">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="idl"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:varname" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:initializer" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>= </xsl:text>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:void" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>void </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:methodname" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:methodparam" mode="idl">
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="d:parameter" mode="idl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template mode="idl" match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$start-modifiers" mode="idl"/>

    <!-- type -->
    <xsl:if test="local-name($notmod[1]) != 'methodname'">
      <xsl:apply-templates select="$notmod[1]" mode="idl"/>
    </xsl:if>

    <xsl:apply-templates select="d:methodname" mode="idl"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="d:methodparam" mode="idl"/>
    <xsl:text>)</xsl:text>
    <xsl:if test="d:exceptionname">
      <xsl:text>
.
</xsl:text>
      <xsl:text>    raises(</xsl:text>
      <xsl:apply-templates select="d:exceptionname" mode="idl"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$end-modifiers" mode="idl"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- ===== Perl ======================================================== -->

<xsl:template match="d:classsynopsis" mode="perl">
  <xsl:text>.sp
</xsl:text><xsl:text>.nf
</xsl:text><pre>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>package </xsl:text>
    <xsl:apply-templates select="d:ooclass[1]" mode="perl"/>
    <xsl:text>;</xsl:text>
    <xsl:text>
.
</xsl:text>

    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text>@ISA = (</xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="perl"/>
      <xsl:text>);</xsl:text>
      <xsl:text>
.
</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="d:constructorsynopsis                                  |d:destructorsynopsis                                  |d:fieldsynopsis                                  |d:methodsynopsis                                  |d:classsynopsisinfo" mode="perl"/>
  </pre><xsl:text/><xsl:text>.fi
</xsl:text>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="perl">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
    <xsl:if test="following-sibling::*">
      <xsl:text> </xsl:text>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template match="d:classname" mode="perl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:interfacename" mode="perl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:exceptionname" mode="perl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="perl">
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:classsynopsis">
      <xsl:text>  </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="perl"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:varname" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:initializer" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>= </xsl:text>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:void" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>void </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:methodname" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:methodparam" mode="perl">
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="d:parameter" mode="perl">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template mode="perl" match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>

  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:text>sub </xsl:text>

    <xsl:apply-templates select="d:methodname" mode="perl"/>
    <xsl:text> { ... };</xsl:text>
  </code>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- Used when not occurring as a child of classsynopsis -->
<xsl:template match="d:ooclass|d:oointerface|d:ooexception">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<!-- * DocBook 5 allows linking elements (link, olink, and xref) -->
<!-- * within the OO *synopsis elements (classsynopsis, fieldsynopsis, -->
<!-- * methodsynopsis, constructorsynopsis, destructorsynopsis) and -->
<!-- * their children. So we need to have mode="java|cpp|idl|perl" -->
<!-- * per-mode matches for those linking elements in order for them -->
<!-- * to be processed as expected. -->

<xsl:template match="d:link|d:olink|d:xref" mode="java">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="cpp">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="idl">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="perl">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="ansi-nontabular">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="ansi-tabular">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="kr-nontabular">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:link|d:olink|d:xref" mode="kr-tabular">
  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>

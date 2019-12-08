<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY RE "&#10;">
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- synopsis is in verbatim -->

<!-- ==================================================================== -->

<xsl:template match="d:cmdsynopsis">
  <fo:block xsl:use-attribute-sets="normal.para.spacing">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:cmdsynopsis/d:command">
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
  <fo:block/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:synopfragmentref">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="synopfragment.number"/>
  </xsl:variable>
  <fo:inline font-style="italic">
    <fo:basic-link internal-destination="{@linkend}"
                   xsl:use-attribute-sets="xref.properties">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$snum"/>
      <xsl:text>)</xsl:text>
    </fo:basic-link>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:synopfragment" mode="synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="d:synopfragment">
  <xsl:variable name="snum">
    <xsl:apply-templates select="." mode="synopfragment.number"/>
  </xsl:variable>
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <fo:block id="{$id}">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$snum"/>
    <xsl:text>)</xsl:text>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:funcsynopsis">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="d:funcsynopsisinfo">
  <fo:block space-after.minimum="0.8em"
            space-after.optimum="1em"
            space-after.maximum="1.2em">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:funcprototype">

  <xsl:variable name="style">
    <xsl:call-template name="funcsynopsis.style"/>
  </xsl:variable>

  <fo:block font-family="{$monospace.font.family}"
          space-before.minimum="0.8em"
          space-before.optimum="1em"
          space-before.maximum="1.2em">
    <xsl:apply-templates/>
    
    <xsl:if test="$style='kr'">
      <fo:block
          space-before.minimum="0.8em"
          space-before.optimum="1em"
          space-before.maximum="1.2em">
      <xsl:apply-templates select="./d:paramdef" mode="kr-funcsynopsis-mode"/>
      </fo:block>
    </xsl:if>

  </fo:block>
</xsl:template>

<xsl:template match="d:funcdef">
  <fo:inline font-family="{$monospace.font.family}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:funcdef/d:function">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <fo:inline font-weight="bold">
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:void">

  <xsl:variable name="style">
    <xsl:call-template name="funcsynopsis.style"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$style='ansi'">
      <xsl:text>(void);</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>();</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:varargs">
  <xsl:text>(...);</xsl:text>
</xsl:template>

<xsl:template match="d:paramdef">

  <xsl:variable name="style">
    <xsl:call-template name="funcsynopsis.style"/>
  </xsl:variable>
  
  <xsl:variable name="paramnum">
    <xsl:number count="d:paramdef" format="1"/>
  </xsl:variable>
  <xsl:if test="$paramnum=1">(</xsl:if>
  <xsl:choose>
    <xsl:when test="$style='ansi'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="./d:parameter"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="following-sibling::d:paramdef">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:paramdef/d:parameter">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <xsl:call-template name="inline.italicseq"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="following-sibling::d:parameter">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:paramdef" mode="kr-funcsynopsis-mode">
  <fo:block>
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template match="d:funcparams">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- Return value of PI or parameter -->
<xsl:template name="funcsynopsis.style">
  <xsl:variable name="pi.style">
    <xsl:call-template name="pi.dbfo_funcsynopsis-style">
      <xsl:with-param name="node" select="ancestor::d:funcsynopsis/descendant-or-self::*"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$pi.style != ''">
      <xsl:value-of select="$pi.style"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$funcsynopsis.style"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:variable name="default-classsynopsis-language">java</xsl:variable>

<xsl:template match="d:classsynopsis
                     |d:fieldsynopsis
                     |d:methodsynopsis
                     |d:constructorsynopsis
                     |d:destructorsynopsis">
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

  <!--
  <xsl:message>process <xsl:value-of select="local-name(.)"/> in <xsl:value-of select="$language"/></xsl:message>
  -->

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
	<xsl:with-param name="language"
	  select="$default-classsynopsis-language"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="synop-break">
  <xsl:if test="parent::d:classsynopsis
                or (following-sibling::d:fieldsynopsis
                    |following-sibling::d:methodsynopsis
                    |following-sibling::d:constructorsynopsis
                    |following-sibling::d:destructorsynopsis)">
    <fo:inline>&RE;</fo:inline>
  </xsl:if>
</xsl:template>

<!-- ===== Java ======================================================== -->

<xsl:template match="d:classsynopsis" mode="java">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:apply-templates select="d:ooclass[1]" mode="java"/>
    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text> extends</xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="java"/>
      <xsl:if test="d:oointerface|d:ooexception">
        <xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:oointerface">
      <xsl:text>implements</xsl:text>
      <xsl:apply-templates select="d:oointerface" mode="java"/>
      <xsl:if test="d:ooexception">
	<xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:ooexception">
      <xsl:text>throws</xsl:text>
      <xsl:apply-templates select="d:ooexception" mode="java"/>
    </xsl:if>
    <xsl:text>&nbsp;{&RE;</xsl:text>
    <xsl:apply-templates select="d:constructorsynopsis
                                 |d:destructorsynopsis
                                 |d:fieldsynopsis
                                 |d:methodsynopsis
                                 |d:classsynopsisinfo" mode="java"/>
    <xsl:text>}</xsl:text>
  </fo:block>
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
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="java">
  <xsl:apply-templates mode="java"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>&nbsp;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:classname" mode="java">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:interfacename" mode="java">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:exceptionname" mode="java">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="java">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>&nbsp;&nbsp;</xsl:text>
    <xsl:apply-templates mode="java"/>
    <xsl:text>;</xsl:text>
    <xsl:call-template name="synop-break"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:type" mode="java">
  <xsl:apply-templates mode="java"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:varname" mode="java">
  <xsl:apply-templates mode="java"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:initializer" mode="java">
  <xsl:text>=&nbsp;</xsl:text>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:void" mode="java">
  <xsl:text>void&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:methodname" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:methodparam" mode="java">
  <xsl:param name="indent">0</xsl:param>
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>,&RE;</xsl:text>
    <xsl:if test="$indent &gt; 0">
      <xsl:call-template name="copy-string">
	<xsl:with-param name="string">&nbsp;</xsl:with-param>
	<xsl:with-param name="count" select="$indent + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="d:parameter" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template mode="java"
  match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="decl">
    <xsl:text>  </xsl:text>
    <xsl:apply-templates select="$start-modifiers" mode="java"/>

    <!-- type -->
    <xsl:if test="local-name($notmod[1]) != 'methodname'">
      <xsl:apply-templates select="$notmod[1]" mode="java"/>
    </xsl:if>

    <xsl:apply-templates select="d:methodname" mode="java"/>
  </xsl:variable>

  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:copy-of select="$decl"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="d:methodparam" mode="java">
      <xsl:with-param name="indent" select="string-length($decl)"/>
    </xsl:apply-templates>
    <xsl:text>)</xsl:text>
    <xsl:if test="d:exceptionname">
      <xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;throws&nbsp;</xsl:text>
      <xsl:apply-templates select="d:exceptionname" mode="java"/>
    </xsl:if>
    <xsl:if test="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$end-modifiers" mode="java"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </fo:block>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- ===== C++ ========================================================= -->

<xsl:template match="d:classsynopsis" mode="cpp">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:apply-templates select="d:ooclass[1]" mode="cpp"/>
    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="cpp"/>
      <xsl:if test="d:oointerface|d:ooexception">
	<xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:oointerface">
      <xsl:text> implements</xsl:text>
      <xsl:apply-templates select="d:oointerface" mode="cpp"/>
      <xsl:if test="d:ooexception">
	<xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:ooexception">
      <xsl:text> throws</xsl:text>
      <xsl:apply-templates select="d:ooexception" mode="cpp"/>
    </xsl:if>
    <xsl:text>&nbsp;{&RE;</xsl:text>
    <xsl:apply-templates select="d:constructorsynopsis
                                 |d:destructorsynopsis
                                 |d:fieldsynopsis
                                 |d:methodsynopsis
                                 |d:classsynopsisinfo" mode="cpp"/>
    <xsl:text>}</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="cpp">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
    <xsl:if test="following-sibling::*">
      <xsl:text>&nbsp;</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="d:classname" mode="cpp">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:interfacename" mode="cpp">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:exceptionname" mode="cpp">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="cpp">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>&nbsp;&nbsp;</xsl:text>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text>;</xsl:text>
  </fo:block>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:varname" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:initializer" mode="cpp">
  <xsl:text>=&nbsp;</xsl:text>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:void" mode="cpp">
  <xsl:text>void&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:methodname" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:methodparam" mode="cpp">
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="d:parameter" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template mode="cpp"
  match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>

  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>  </xsl:text>
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
      <xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;throws&nbsp;</xsl:text>
      <xsl:apply-templates select="d:exceptionname" mode="cpp"/>
    </xsl:if>
    <xsl:if test="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$end-modifiers" mode="cpp"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </fo:block>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- ===== IDL ========================================================= -->

<xsl:template match="d:classsynopsis" mode="idl">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>interface </xsl:text>
    <xsl:apply-templates select="d:ooclass[1]" mode="idl"/>
    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="idl"/>
      <xsl:if test="d:oointerface|d:ooexception">
	<xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:oointerface">
      <xsl:text> implements</xsl:text>
      <xsl:apply-templates select="d:oointerface" mode="idl"/>
      <xsl:if test="d:ooexception">
	<xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="d:ooexception">
      <xsl:text> throws</xsl:text>
      <xsl:apply-templates select="d:ooexception" mode="idl"/>
    </xsl:if>
    <xsl:text>&nbsp;{&RE;</xsl:text>
    <xsl:apply-templates select="d:constructorsynopsis
                                 |d:destructorsynopsis
                                 |d:fieldsynopsis
                                 |d:methodsynopsis
                                 |d:classsynopsisinfo" mode="idl"/>
    <xsl:text>}</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="idl">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="idl">
  <xsl:apply-templates mode="idl"/>
    <xsl:if test="following-sibling::*">
      <xsl:text>&nbsp;</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="d:classname" mode="idl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:interfacename" mode="idl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:exceptionname" mode="idl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="idl">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>&nbsp;&nbsp;</xsl:text>
    <xsl:apply-templates mode="idl"/>
    <xsl:text>;</xsl:text>
  </fo:block>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="idl">
  <xsl:apply-templates mode="idl"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:varname" mode="idl">
  <xsl:apply-templates mode="idl"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:initializer" mode="idl">
  <xsl:text>=&nbsp;</xsl:text>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:void" mode="idl">
  <xsl:text>void&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:methodname" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:methodparam" mode="idl">
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="d:parameter" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template mode="idl"
  match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>

  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>  </xsl:text>
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
      <xsl:text>&RE;&nbsp;&nbsp;&nbsp;&nbsp;raises(</xsl:text>
      <xsl:apply-templates select="d:exceptionname" mode="idl"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$end-modifiers" mode="idl"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </fo:block>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<!-- ===== Perl ======================================================== -->

<xsl:template match="d:classsynopsis" mode="perl">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>package </xsl:text>
    <xsl:apply-templates select="d:ooclass[1]" mode="perl"/>
    <xsl:text>;&RE;</xsl:text>

    <xsl:if test="d:ooclass[preceding-sibling::*]">
      <xsl:text>@ISA = (</xsl:text>
      <xsl:apply-templates select="d:ooclass[preceding-sibling::*]" mode="perl"/>
      <xsl:text>);&RE;</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="d:constructorsynopsis
                                 |d:destructorsynopsis
                                 |d:fieldsynopsis
                                 |d:methodsynopsis
                                 |d:classsynopsisinfo" mode="perl"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:classsynopsisinfo" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:ooclass|d:oointerface|d:ooexception" mode="perl">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:modifier|d:package" mode="perl">
  <xsl:apply-templates mode="perl"/>
    <xsl:if test="following-sibling::*">
      <xsl:text>&nbsp;</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="d:classname" mode="perl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:interfacename" mode="perl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:exceptionname" mode="perl">
  <xsl:if test="local-name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:fieldsynopsis" mode="perl">
  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>&nbsp;&nbsp;</xsl:text>
    <xsl:apply-templates mode="perl"/>
    <xsl:text>;</xsl:text>
  </fo:block>
  <xsl:call-template name="synop-break"/>
</xsl:template>

<xsl:template match="d:type" mode="perl">
  <xsl:apply-templates mode="perl"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:varname" mode="perl">
  <xsl:apply-templates mode="perl"/>
  <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:initializer" mode="perl">
  <xsl:text>=&nbsp;</xsl:text>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:void" mode="perl">
  <xsl:text>void&nbsp;</xsl:text>
</xsl:template>

<xsl:template match="d:methodname" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:methodparam" mode="perl">
  <xsl:if test="preceding-sibling::d:methodparam">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="d:parameter" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template mode="perl"
  match="d:constructorsynopsis|d:destructorsynopsis|d:methodsynopsis">
  <xsl:variable name="start-modifiers" select="d:modifier[following-sibling::*[local-name(.) != 'modifier']]"/>
  <xsl:variable name="notmod" select="*[local-name(.) != 'modifier']"/>
  <xsl:variable name="end-modifiers" select="d:modifier[preceding-sibling::*[local-name(.) != 'modifier']]"/>

  <fo:block wrap-option='no-wrap'
            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:text>sub </xsl:text>

    <xsl:apply-templates select="d:methodname" mode="perl"/>
    <xsl:text> { ... };</xsl:text>
    <xsl:call-template name="synop-break"/>
  </fo:block>
</xsl:template>

<!-- Used when not occurring as a child of classsynopsis -->
<xsl:template match="d:ooclass|d:oointerface|d:ooexception|d:modifier|d:initializer">
  <fo:inline>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:inline>
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

</xsl:stylesheet>

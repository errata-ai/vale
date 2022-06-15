<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "../common/entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="xlink d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:glossary">
  &setup-language-variable;
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="glossary.titlepage"/>

    <xsl:choose>
      <xsl:when test="d:glossdiv">
        <xsl:apply-templates select="(d:glossdiv[1]/preceding-sibling::*)"/>
      </xsl:when>
      <xsl:when test="d:glossentry">
        <xsl:apply-templates select="(d:glossentry[1]/preceding-sibling::*)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="d:glossdiv">
        <xsl:apply-templates select="d:glossdiv"/>
      </xsl:when>
      <xsl:when test="d:glossentry">
        <dl>
          <xsl:choose>
            <xsl:when test="$glossary.sort != 0">
              <xsl:apply-templates select="d:glossentry">
				<xsl:sort lang="{$language}" select="normalize-space(translate(concat(@sortas, d:glossterm[not(parent::d:glossentry/@sortas) or parent::d:glossentry/@sortas = '']), &lowercase;, &uppercase;))"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="d:glossentry"/>
            </xsl:otherwise>
          </xsl:choose>
        </dl>
      </xsl:when>
      <xsl:otherwise>
        <!-- empty glossary -->
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="d:bibliography"/>

    <xsl:if test="not(parent::d:article)">
      <xsl:call-template name="process.footnotes"/>
    </xsl:if>
  </xsl:element>
</xsl:template>

<xsl:template match="d:glossary/d:glossaryinfo"></xsl:template>
<xsl:template match="d:glossary/d:info"></xsl:template>
<xsl:template match="d:glossary/d:title"></xsl:template>
<xsl:template match="d:glossary/d:subtitle"></xsl:template>
<xsl:template match="d:glossary/d:titleabbrev"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:glosslist">
  &setup-language-variable;
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="d:blockinfo/d:title|d:info/d:title|d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>
    <dl>
      <xsl:choose>
        <xsl:when test="$glossary.sort != 0">
          <xsl:apply-templates select="d:glossentry">
				<xsl:sort lang="{$language}" select="normalize-space(translate(concat(@sortas, d:glossterm[not(parent::d:glossentry/@sortas) or parent::d:glossentry/@sortas = '']), &lowercase;, &uppercase;))"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="d:glossentry"/>
        </xsl:otherwise>
      </xsl:choose>
    </dl>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:glossdiv">
  &setup-language-variable;
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="(d:glossentry[1]/preceding-sibling::*)"/>

    <dl>
      <xsl:choose>
        <xsl:when test="$glossary.sort != 0">
          <xsl:apply-templates select="d:glossentry">
            <xsl:sort lang="{$language}"
                      select="translate(d:glossterm, $lowercase,
                                        $uppercase)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="d:glossentry"/>
        </xsl:otherwise>
      </xsl:choose>
    </dl>
  </div>
</xsl:template>

<xsl:template match="d:glossdiv/d:title">
  <h3>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<!-- ==================================================================== -->

<!--
GlossEntry ::=
  GlossTerm, Acronym?, Abbrev?,
  (IndexTerm)*,
  RevHistory?,
  (GlossSee | GlossDef+)
-->

<xsl:template match="d:glossentry">
  <xsl:choose>
    <xsl:when test="$glossentry.show.acronym = 'primary'">
      <dt>
        <xsl:call-template name="id.attribute">
          <xsl:with-param name="conditional">
            <xsl:choose>
              <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional">
            <xsl:choose>
              <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:choose>
          <xsl:when test="d:acronym|d:abbrev">
            <xsl:apply-templates select="d:acronym|d:abbrev"/>
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="d:glossterm"/>
            <xsl:text>)</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="d:glossterm"/>
          </xsl:otherwise>
        </xsl:choose>
      </dt>
    </xsl:when>
    <xsl:when test="$glossentry.show.acronym = 'yes'">
      <dt>
        <xsl:call-template name="id.attribute">
          <xsl:with-param name="conditional">
            <xsl:choose>
              <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional">
            <xsl:choose>
              <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:apply-templates select="d:glossterm"/>

        <xsl:if test="d:acronym|d:abbrev">
          <xsl:text> (</xsl:text>
          <xsl:apply-templates select="d:acronym|d:abbrev"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="d:indexterm"/>
      </dt>
    </xsl:when>
    <xsl:otherwise>
      <dt>
        <xsl:call-template name="id.attribute">
          <xsl:with-param name="conditional">
            <xsl:choose>
              <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional">
            <xsl:choose>
              <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:apply-templates select="d:glossterm"/>
        <xsl:apply-templates select="d:indexterm"/>
      </dt>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="d:glosssee|d:glossdef"/>
</xsl:template>

<xsl:template match="d:glossentry/d:glossterm">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::d:glossterm">, </xsl:if>
</xsl:template>

<xsl:template match="d:glossentry/d:acronym">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::d:acronym|following-sibling::d:abbrev">, </xsl:if>
</xsl:template>

<xsl:template match="d:glossentry/d:abbrev">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::d:acronym|following-sibling::d:abbrev">, </xsl:if>
</xsl:template>

<xsl:template match="d:glossentry/d:revhistory">
</xsl:template>

<xsl:template match="d:glossentry/d:glosssee">
  <xsl:variable name="otherterm" select="@otherterm"/>
  <xsl:variable name="targets" select="key('id', $otherterm)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="xlink" select="@xlink:href"/>

  <dd>
    <p>
      <xsl:variable name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'glossary'"/>
          <xsl:with-param name="name" select="'see'"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="title">
        <xsl:choose>
          <xsl:when test="$target">
            <a>
              <xsl:apply-templates select="." mode="common.html.attributes"/>
              <xsl:call-template name="id.attribute"/>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="object" select="$target"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:apply-templates select="$target" mode="xref-to"/>
            </a>
          </xsl:when>
          <xsl:when test="$xlink">
            <xsl:call-template name="simple.xlink">
              <xsl:with-param name="content">
                <xsl:apply-templates/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$otherterm != '' and not($target)">
            <xsl:message>
              <xsl:text>Warning: glosssee @otherterm reference not found: </xsl:text>
              <xsl:value-of select="$otherterm"/>
            </xsl:message>
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template" select="$template"/>
        <xsl:with-param name="title" select="$title"/>
      </xsl:call-template>
    </p>
  </dd>
</xsl:template>

<xsl:template match="d:glossentry/d:glossdef">
  <dd>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates select="*[local-name(.) != 'glossseealso']"/>
    <xsl:if test="d:glossseealso">
      <p>
        <xsl:variable name="template">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'glossary'"/>
            <xsl:with-param name="name" select="'seealso'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:apply-templates select="d:glossseealso"/>
        </xsl:variable>
        <xsl:call-template name="substitute-markup">
          <xsl:with-param name="template" select="$template"/>
          <xsl:with-param name="title" select="$title"/>
        </xsl:call-template>
      </p>
    </xsl:if>
  </dd>
</xsl:template>

<xsl:template match="d:glossseealso">
  <xsl:variable name="otherterm" select="@otherterm"/>
  <xsl:variable name="targets" select="key('id', $otherterm)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="xlink" select="@xlink:href"/>

  <xsl:choose>
    <xsl:when test="$target">
      <a>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="$target" mode="xref-to"/>
      </a>
    </xsl:when>
    <xsl:when test="$xlink">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:apply-templates/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$otherterm != '' and not($target)">
      <xsl:message>
        <xsl:text>Warning: glossseealso @otherterm reference not found: </xsl:text>
        <xsl:value-of select="$otherterm"/>
      </xsl:message>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="position() = last()"/>
    <xsl:otherwise>
		<xsl:call-template name="gentext.template">
		  <xsl:with-param name="context" select="'glossary'"/>
		  <xsl:with-param name="name" select="'seealso-separator'"/>
		</xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Glossary collection -->

<xsl:template match="d:glossary[@role='auto']" priority="2">
  &setup-language-variable;
  <xsl:variable name="terms" 
                select="//d:glossterm[not(parent::d:glossdef)]|//d:firstterm"/>
  <xsl:variable name="collection" select="document($glossary.collection, .)"/>

  <xsl:call-template name="id.warning"/>

  <xsl:if test="$glossary.collection = ''">
    <xsl:message>
      <xsl:text>Warning: processing automatic glossary </xsl:text>
      <xsl:text>without a glossary.collection file.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="not($collection) and $glossary.collection != ''">
    <xsl:message>
      <xsl:text>Warning: processing automatic glossary but unable to </xsl:text>
      <xsl:text>open glossary.collection file '</xsl:text>
      <xsl:value-of select="$glossary.collection"/>
      <xsl:text>'</xsl:text>
    </xsl:message>
  </xsl:if>

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="glossary.titlepage"/>

    <xsl:choose>
      <xsl:when test="d:glossdiv and $collection//d:glossdiv">
        <xsl:for-each select="$collection//d:glossdiv">
          <!-- first see if there are any in this div -->
          <xsl:variable name="exist.test">
            <xsl:for-each select="d:glossentry">
              <xsl:variable name="cterm" select="d:glossterm"/>
              <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
                <xsl:value-of select="d:glossterm"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>

          <xsl:if test="$exist.test != ''">
            <xsl:apply-templates select="." mode="auto-glossary">
              <xsl:with-param name="terms" select="$terms"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <dl>
          <xsl:choose>
            <xsl:when test="$glossary.sort != 0">
              <xsl:for-each select="$collection//d:glossentry">
				<xsl:sort lang="{$language}" select="normalize-space(translate(concat(@sortas, d:glossterm[not(parent::d:glossentry/@sortas) or parent::d:glossentry/@sortas = '']), &lowercase;, &uppercase;))"/>
                <xsl:variable name="cterm" select="d:glossterm"/>
                <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
                  <xsl:apply-templates select="." mode="auto-glossary"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$collection//d:glossentry">
                <xsl:variable name="cterm" select="d:glossterm"/>
                <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
                  <xsl:apply-templates select="." mode="auto-glossary"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </dl>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="not(parent::d:article)">
      <xsl:call-template name="process.footnotes"/>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="*" mode="auto-glossary">
  <!-- pop back out to the default mode for most elements -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:glossdiv" mode="auto-glossary">
  <xsl:param name="terms" select="."/>

  &setup-language-variable;

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="(d:glossentry[1]/preceding-sibling::*)"/>

    <dl>
      <xsl:choose>
        <xsl:when test="$glossary.sort != 0">
          <xsl:for-each select="d:glossentry">
				<xsl:sort lang="{$language}" select="normalize-space(translate(concat(@sortas, d:glossterm[not(parent::d:glossentry/@sortas) or parent::d:glossentry/@sortas = '']), &lowercase;, &uppercase;))"/>
            <xsl:variable name="cterm" select="d:glossterm"/>
            <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
              <xsl:apply-templates select="." mode="auto-glossary"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="d:glossentry">
            <xsl:variable name="cterm" select="d:glossterm"/>
            <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
              <xsl:apply-templates select="." mode="auto-glossary"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </dl>
  </div>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

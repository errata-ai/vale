<?xml version='1.0'?>
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

<!-- These templates define the "default behavior" for info
     elements.  Even if you don't process the *info wrappers,
     some of these elements are needed because the elements are
     processed from named templates that are called with modes.
     Since modes aren't sticky, these rules apply. 
     (TODO: clarify this comment) -->

<!-- ==================================================================== -->
<!-- called from named templates in a given mode -->

<xsl:template match="d:corpauthor">
  <fo:inline>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

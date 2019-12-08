<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns:epub="http://www.idpf.org/2007/ops"
  exclude-result-prefixes="exsl d"
  version="1.0">

<!-- This is the main driver stylesheet file.  It imports or
includes all the components that it needs. -->

<!-- Import the module that customizes docbook elements -->
<!-- Put any customizations of element content in this module. -->
<xsl:import href="docbook.xsl"/>

<xsl:import href="../xhtml/chunk-common.xsl"/>

<xsl:include href="../xhtml/chunk-code.xsl"/>

<!-- The following module has templates that override the stock
     xhtml templates for HTML5 output.  
     It contains match templates with priority="1" attributes,
     and named templates.  These override any templates that
     handle chunking behavior -->
<xsl:include href="epub3-chunk-mods.xsl"/>

</xsl:stylesheet>

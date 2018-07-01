<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************

XSLT name:    common.xslt

Version:  4.9

Date: 2016-01-18

Purpose:  Templates common to SchemaLightener set of tools.

**********************************************************************
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="fn " xmlns="" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">

	<!-- ******************************** 
		fileRelationMappingIncludes   
		Walks tree of include statements collecting artifacts.
		******************************** -->
	<xsl:template name="fileRelationMappingIncludes">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="contextPathAndFileName"/>
		<xsl:param name="schemaLocationStringRecursionCheck"/>
		<xsl:variable name="schemaLocation1">
			<xsl:value-of select="translate(@schemaLocation,'\','/')"/>
		</xsl:variable>
		<xsl:variable name="schemaLocation">
			<xsl:choose>
				<xsl:when test="starts-with($schemaLocation1,'./')">
					<xsl:value-of select="substring-after($schemaLocation1,'./')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$schemaLocation1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- fullIncludeImportFilePathAndName is the fully qualified path to the file, having had relative directories chopped off 
			as necessary based on schemaLocation
		-->
		<xsl:variable name="fullIncludeImportFilePathAndName">
			<xsl:choose>
				<xsl:when test="starts-with($schemaLocation,'http')">
					<xsl:value-of select="$schemaLocation"/>
				</xsl:when>
				<xsl:when test="contains($schemaLocation,'../')">
					<xsl:call-template name="chopNDirectories">
						<xsl:with-param name="contextBasePath">
							<xsl:value-of select="$contextBasePath"/>
						</xsl:with-param>
						<xsl:with-param name="location">
							<xsl:value-of select="$schemaLocation"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$contextBasePath"/>
					<xsl:value-of select="$schemaLocation"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- newContextBasePath is the path minus the filename, so relative links can work from there -->
		<xsl:variable name="newContextBasePath">
			<xsl:call-template name="findNewContextBasePath">
				<xsl:with-param name="contextBasePath">
					<xsl:value-of select="$fullIncludeImportFilePathAndName"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ns">
			<xsl:choose>
				<xsl:when test="local-name()='include'">
					<xsl:for-each-group select="xsd:schema/namespace::node()" group-by="name(.)">
						<xsl:if test=".=//xsd:schema/@targetNamespace and name(.)!=''">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@namespace"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="not(ends-with($fullIncludeImportFilePathAndName,'/'))">
			<!-- 
				this is a major if.
				in a situation where an xsd:import does not contain a @schemaLocation, you may 
				get valid results but also an error thrown as the parser tries to locate the schema via the namespace
				this IF tells the process to NOT import xsd:imports with no @schemaLocation.
				since any imports are included in the wsdl itself, this should resolve the error and still give good results
				see openaxis schemas as an example.
			-->

			<file type="{name()}" ns="{$ns}" match="//xsd:schema" mode="fileRelationMapping">
				<name>
					<xsl:value-of select="$fullIncludeImportFilePathAndName"/>
				</name>
				<!-- inscoprefixes and ns work are set at context of the include/import and not the root of that schema -->
				<xsl:variable name="inscopeprefixes" select="in-scope-prefixes(.)"/>
				<xsl:element name="nsprefixesinscope" inherit-namespaces="yes">
					<xsl:value-of select="$inscopeprefixes"/>
				</xsl:element>
				<ns>
					<xsl:variable name="thisnode" select="."/>
					<xsl:for-each select="$inscopeprefixes">
						<xsl:variable name="this" select="."/>
						<xsl:attribute name="_{.}">
							<xsl:value-of select="namespace-uri-for-prefix($this,$thisnode)"/>
						</xsl:attribute>
					</xsl:for-each>
				</ns>

				<schemaLocationStringRecursionCheck>
					<xsl:value-of select="$schemaLocationStringRecursionCheck"/>
				</schemaLocationStringRecursionCheck>
				<relativename>
					<xsl:value-of
						select="substring-after($fullIncludeImportFilePathAndName,$sourceBasePath)"
					/>
				</relativename>
				<xsl:if test="doc-available($fullIncludeImportFilePathAndName)=false">
					<xsl:value-of select="$fullIncludeImportFilePathAndName"/>
				</xsl:if>
				<xsl:if test="doc-available($fullIncludeImportFilePathAndName)">
					<xsl:variable name="includeFile"
						select="document($fullIncludeImportFilePathAndName)"/>
					<xsl:for-each
						select="$includeFile/xsd:schema/xsd:import | $includeFile/xsd:schema/xsd:include">
						<!-- fullIncludeImportFilePathAndName is the fully qualified path to the file, having had relative directories chopped off 
						as necessary based on schemaLocation -->
						<xsl:variable name="thisfullIncludeImportFilePathAndName">
							<xsl:choose>
								<xsl:when test="contains(translate(@schemaLocation,'\','/'),'../')">
									<xsl:call-template name="chopNDirectories">
										<xsl:with-param name="contextBasePath">
											<xsl:value-of select="$newContextBasePath"/>
										</xsl:with-param>
										<xsl:with-param name="location">
											<xsl:value-of
												select="translate(@schemaLocation,'\','/')"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$newContextBasePath"/>
									<xsl:value-of select="translate(@schemaLocation,'\','/')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="thisnewContextBasePath">
							<xsl:call-template name="findNewContextBasePath">
								<xsl:with-param name="contextBasePath">
									<xsl:value-of select="$thisfullIncludeImportFilePathAndName"/>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:value-of
								select="translate(substring-after(@namespace,'://'),'\/*?:|','______')"
							/>/ </xsl:variable>
						<xsl:variable name="resultPathAndFileName">
							<xsl:value-of
								select="substring-after($thisfullIncludeImportFilePathAndName,$thisnewContextBasePath)"
							/>
						</xsl:variable>
						<xsl:variable name="resultFileName">
							<!--<xsl:value-of select="$resultBasePathTranslated"/>-->
							<xsl:value-of select="$resultPathAndFileName"/>
						</xsl:variable>
						<!-- recursion check -->
						<xsl:choose>
							<xsl:when
								test="contains($schemaLocationStringRecursionCheck,concat('~',@schemaLocation,'~'))"
								><!-- recursive, so don't do it --></xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="fileRelationMappingIncludes">
									<xsl:with-param name="contextBasePath">
										<xsl:value-of select="$newContextBasePath"/>
									</xsl:with-param>
									<xsl:with-param name="contextPathAndFileName">
										<xsl:value-of select="$resultPathAndFileName"/>
									</xsl:with-param>
									<xsl:with-param name="schemaLocationStringRecursionCheck">
										<xsl:value-of select="$schemaLocationStringRecursionCheck"
											/>~<xsl:value-of select="@schemaLocation"
										/>~</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:for-each>
				</xsl:if>
			</file>
		</xsl:if>
	</xsl:template>

	<!-- ******************************** 
  match="@*" mode="fileRelationMappingFinal"   
  Final mapping for series of includes
  ******************************** -->

	<xsl:template match="@*" mode="fileRelationMappingFinal">
		<!-- this is a blanket copy for any nodes not specifically acted on below -->
		<xsl:choose>
			<xsl:when test=".=''">
				<xsl:attribute name="ns">
					<xsl:value-of select="ancestor::file[@ns!=''][1]/@ns"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ******************************** 
  match="* | text()" mode="fileRelationMappingFinal"   
    Final mapping for series of includes
 ******************************** -->
	<xsl:template match="* | text()" mode="fileRelationMappingFinal">
		<!-- this is a blanket copy for any nodes not specifically acted on below -->
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="fileRelationMappingFinal"/>
			<xsl:apply-templates mode="fileRelationMappingFinal"/>
		</xsl:copy>
	</xsl:template>

	<!-- ******************************** 
match="file" mode="fileRelationMappingFinal"
  Final mapping for series of includes
 ******************************** -->
	<xsl:template match="file" mode="fileRelationMappingFinal">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="fileRelationMappingFinal"/>
			<xsl:apply-templates mode="fileRelationMappingFinal"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="comment()">
		<xsl:copy/>
	</xsl:template>
</xsl:stylesheet>

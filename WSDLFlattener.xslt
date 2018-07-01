<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************

XSLT name:    WSDLFlattener.xslt

Version:  4.9

Date: 2016-01-18

Purpose:  This stylesheet merges all wsdl:imports into a single WSDL.  In addition, it merges all schemas in the <types> section into the result wsdl.

Notes:  Because all schema includes and imports are put into the result wsdl, the <types> element may have multiple xsd:schema elements.
However some tools will only support one schema per targetNamespace.  So this WSDLFlattener also flattens the xsd:schemas themselves.  
So while there may be multiple schemas in the <types> element, there is only one schema per default/targetNamespace.
- xsd:imports with no @schemaLocation are omitted from the result. 

This stylesheet grew out of an original requirement for Xslt 1.0 technology only.  It has since been significantly improved using Xslt 2.0 and will continue to develop beyond the initial 1.0 requirement.  


**********************************************************************
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="fn " xmlns="" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no"/>
	<xsl:include href="common.xslt"/>
	<xsl:include href="directories.xslt"/>
	<!--
Parameters:
  
sourcePathAndFileName: This is the name and full path of the WSDL that is to be flattened.  

resultBasePath:  This is the path to a folder where the results of the transformation will be placed.  
Make sure permissions are set at this location so the transformation can be created properly.

Notes on parameters and XSLT processors:
1.  Some XSLT processors require "file:///" to precede a full drive or network path, e.g.

	<xsl:param name="sourcePathAndFileName">file:///c:/xmlWSDLs/SamplePostalAddress.wsdl</xsl:param>

A relative path does not require the "file:///" to precede it.
2.  Some XSLT processors will not work well with back slashes "\" and so forward slashes "/" are recommended.
3.  Some XSLT processors may need trailing forward slash "/" to correctly create the result, as in:

	<xsl:param name="resultBasePath">file:///c:/xmlWSDLs/flattened/result/</xsl:param>

The trailing forward slash is therefore recommended.

-->
	<xsl:param name="resultBasePath"/>
	<xsl:variable name="sourcePathAndFileName" select="document-uri(.)"/>
	<xsl:variable name="sourcePathAndFileNameTranslated" select="translate($sourcePathAndFileName,'\','/')"/>
	<xsl:variable name="resultBasePathTranslated" select="translate($resultBasePath,'\','/')"/>
	<xsl:variable name="rootFileName">
		<xsl:value-of select="tokenize($sourcePathAndFileNameTranslated,'/')[last()]"/>
	</xsl:variable>
	<xsl:variable name="sourceBasePath">
		<xsl:value-of select="substring-before($sourcePathAndFileNameTranslated,$rootFileName)"/>
	</xsl:variable>
	<xsl:variable name="resultPathAndFileName">
		<xsl:value-of select="$resultBasePathTranslated"/>
		<xsl:value-of select="$rootFileName"/>
	</xsl:variable>
	
	<!-- ******************************** 
  /       root                                 
 ******************************** -->
	<xsl:template match="/">
		
	
		<xsl:variable name="wsdlFileMappingAsIs">
			<!-- list of file includes and imports as they exist in the original (meaning including duplicates) -->
			<xsl:apply-templates select="wsdl:definitions" mode="wsdlfileRelationMapping">
				<xsl:with-param name="contextBasePath">
					<xsl:value-of select="$sourceBasePath"/>
				</xsl:with-param>
				<xsl:with-param name="contextPathAndFileName">
					<xsl:value-of select="$sourcePathAndFileName"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="wsdlFileMappingForResult">
			<!-- list of files with imports and includes organized with no duplicates -->
			<xsl:apply-templates select="$wsdlFileMappingAsIs/file[ends-with(name,'.wsdl')]" mode="fileRelationMappingFinal"/> 
		</xsl:variable>
		<xsl:variable name="wsdlFileMappingRoot-Final">
			<!-- final list of files with imports and includes for root schema only (and no duplicates) -->
			<xsl:for-each select="$wsdlFileMappingForResult/file[ends-with(name,'.wsdl')]">
				<file type="root" ns="{@ns}" name="wsdlFileMappingRoot-Final">
					<name>
						<xsl:value-of select="name"/>
					</name>
					<xsl:variable name="rootns">
						<xsl:value-of select="@ns"/>
					</xsl:variable>
					<xsl:variable name="rootname">
						<xsl:value-of select="name"/>
					</xsl:variable>
					<xsl:for-each-group select=".//file[@ns=$rootns][ends-with(name,'.xsd') or ends-with(name,'.wsdl')]" group-by="name">
						<!-- imports -->
						<file type="import" ns="{@ns}" name="wsdlFileMappingRoot-Final">
							<name>
								<xsl:value-of select="name"/>
							</name>
						</file>
					</xsl:for-each-group>
					<xsl:for-each-group select=".//file[@ns!=$rootns]" group-by="@ns">
						<!-- imports -->
						<xsl:variable name="ns">
							<xsl:value-of select="@ns"/>
						</xsl:variable>
						<xsl:for-each-group select="current-group()" group-by="name">
							<xsl:variable name="name">
								<xsl:value-of select="name"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$wsdlFileMappingForResult//file[@ns=$ns][file/name=$name]"> </xsl:when>
								<xsl:when test="@ns=$ns">
									<file type="import" ns="{@ns}" name="wsdlFileMappingRoot-Final">
										<name>
											<xsl:value-of select="name"/>
										</name>
									</file>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</file>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="wsdlgenerateOutput">
			<xsl:with-param name="theOutput">
				<master match='/'>
					<xsl:copy-of select="$wsdlFileMappingRoot-Final"/>
				</master>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ******************************** 
  match="//wsdl:definitions" mode="wsdlfileRelationMapping"   
 ******************************** -->
	<xsl:template match="//wsdl:definitions" mode="wsdlfileRelationMapping">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="contextPathAndFileName"/>
		<xsl:variable name="nsdefault">
			<xsl:for-each-group select="namespace::node()" group-by="name(.)">
				<xsl:if test="name(.)=''">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="nstargetNamespace">
			<xsl:value-of select="@targetNamespace"/>
		</xsl:variable>
		<xsl:variable name="ns">
			<xsl:choose>
				<xsl:when test="$nsdefault!=''">
					<xsl:value-of select="$nsdefault"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nstargetNamespace"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<file type="root" ns="{$ns}" match="//wsdl:definitions" mode="wsdlfileRelationMapping">
			<name>
				<xsl:value-of select="$contextPathAndFileName"/>
			</name>
			<xsl:variable name="inscopeprefixes" select="in-scope-prefixes(.)"/>
			<xsl:element name="nsprefixesinscope" inherit-namespaces="yes">
				<xsl:value-of select="$inscopeprefixes"/>
			</xsl:element>
			<ns>
				<xsl:variable name="thisnode" select="."/>
				<xsl:for-each select="$inscopeprefixes">
					<xsl:variable name="this" select="."/>
					<xsl:attribute name="_{.}"><xsl:value-of select="namespace-uri-for-prefix($this,$thisnode)"/></xsl:attribute>
				</xsl:for-each>
			</ns>
			
			<xsl:for-each select="wsdl:import">
				<xsl:call-template name="wsdlfileRelationMappingIncludes">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="$contextBasePath"/>
					</xsl:with-param>
					<xsl:with-param name="contextPathAndFileName">
						<xsl:value-of select="$contextPathAndFileName"/>
					</xsl:with-param>
					<xsl:with-param name="contextNS">
						<xsl:value-of select="$ns"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</file>
	</xsl:template>

	<!-- ******************************** 
  wsdlfileRelationMappingIncludes   
 ******************************** -->
	<xsl:template name="wsdlfileRelationMappingIncludes">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="contextPathAndFileName"/>
		<xsl:param name="contextNS"/>
		<xsl:variable name="schemaLocation">
			<xsl:value-of select="@location"/>
		</xsl:variable>
		<!-- fullIncludeImportFilePathAndName is the fully qualified path to the file, having had relative directories chopped off 
as necessary based on location -->
		<xsl:variable name="fullIncludeImportFilePathAndName">
			<xsl:choose>
				<xsl:when test="contains(translate($schemaLocation,'\','/'),'../')">
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
				<xsl:when test="name()='wsdl:import'">
					<xsl:for-each-group select="wsdl:definitions/namespace::node()" group-by="name(.)">
						<xsl:if test=".=//wsdl:definitions/@targetNamespace and name(.)!=''">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@namespace"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<file type="{name()}" ns="{$ns}" name="wsdlfileRelationMappingIncludes">
			<name>
				<xsl:value-of select="$fullIncludeImportFilePathAndName"/>
			</name>
			<xsl:variable name="inscopeprefixes" select="in-scope-prefixes(.)"/>
			<xsl:element name="nsprefixesinscope" inherit-namespaces="yes">
				<xsl:value-of select="$inscopeprefixes"/>
			</xsl:element>
			<ns>
				<xsl:variable name="thisnode" select="."/>
				<xsl:for-each select="$inscopeprefixes">
					<xsl:variable name="this" select="."/>
					<xsl:attribute name="_{.}"><xsl:value-of select="namespace-uri-for-prefix($this,$thisnode)"/></xsl:attribute>
				</xsl:for-each>
			</ns>
			
			<relativename>
				<xsl:value-of select="substring-after($fullIncludeImportFilePathAndName,$sourceBasePath)"/>
			</relativename>
			<xsl:variable name="includeFile" select="document($fullIncludeImportFilePathAndName)"/>
			<xsl:for-each select="$includeFile/wsdl:definitions/wsdl:import">
				<!-- fullIncludeImportFilePathAndName is the fully qualified path to the file, having had relative directories chopped off 
				as necessary based on schemaLocation -->
				<!-- are these necessary ?  don't think so
					wsdls are merged into one and don't need to do ns as folder names
					***************
				<xsl:variable name="thisfullIncludeImportFilePathAndName">
					<xsl:choose>
						<xsl:when test="contains(translate(@location,'\','/'),'../')">
							<xsl:call-template name="chopNDirectories">
								<xsl:with-param name="contextBasePath">
									<xsl:value-of select="$newContextBasePath"/>
								</xsl:with-param>
								<xsl:with-param name="location">
									<xsl:value-of select="@location"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$newContextBasePath"/>
							<xsl:value-of select="@location"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="thisnewContextBasePath">
					<xsl:call-template name="findNewContextBasePath">
						<xsl:with-param name="contextBasePath">
							<xsl:value-of select="$thisfullIncludeImportFilePathAndName"/>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:value-of select="translate(substring-after(@namespace,'://'),'\/*?:|','______')"/>/ </xsl:variable>
				<xsl:variable name="resultPathAndFileName">
					<xsl:value-of select="substring-after($thisfullIncludeImportFilePathAndName,$thisnewContextBasePath)"/>
				</xsl:variable>
				<xsl:variable name="resultFileName">
					<xsl:value-of select="$resultPathAndFileName"/>
					</xsl:variable>
				-->
				<xsl:call-template name="wsdlfileRelationMappingIncludes">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="$newContextBasePath"/>
					</xsl:with-param>
					<xsl:with-param name="contextPathAndFileName">
						<xsl:value-of select="$resultPathAndFileName"/>
					</xsl:with-param>
					<xsl:with-param name="contextNS">
						<xsl:value-of select="../*/@namespace"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</file>
	</xsl:template>

	<!-- ******************************** 
  wsdlgenerateOutput   
 ******************************** -->
	<xsl:template name="wsdlgenerateOutput">
		<xsl:param name="theOutput"/>
		<xsl:variable name="output">
			<xsl:for-each select="$theOutput//file[@type='root']">
				<xsl:variable name="filename">
					<xsl:value-of select="tokenize(name,'/')[last()]"/>
				</xsl:variable>
				<xsl:variable name="ns">
					<xsl:value-of select="@ns"/>
				</xsl:variable>
				<xsl:variable name="name">
					<xsl:value-of select="name"/>
				</xsl:variable>
				<root filename="{$filename}" ns="{$ns}" name="wsdlgenerateOutput">
					<xsl:for-each select="document(name)/wsdl:definitions">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:for-each select="$theOutput//file[@type='root'][name=$name]//file[@type='import']">
								<xsl:copy-of select="document(name)/wsdl:definitions/*[name()!='wsdl:import']"/>
							</xsl:for-each>
							<xsl:copy-of select="*[name()!='wsdl:import']"/>
						</xsl:copy>
					</xsl:for-each>
				</root>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- foreach output/root only fires once, namely the wsdl file
main loop for entire template -->
		<xsl:for-each select="$output/root">
			<xsl:variable name="filename">
				<xsl:value-of select="@filename"/>
			</xsl:variable>
			<xsl:variable name="ns">
				<xsl:value-of select="@ns"/>
			</xsl:variable>
			<xsl:result-document href="{$resultBasePath}/{@filename}">
				<wsdl:definitions>
					<xsl:for-each-group select="$output/root[@ns!=$ns]/wsdl:definitions/namespace::node()" group-by="name(.)">
						<xsl:if test="name(.)!='targetNamespace' and name(.)!=''">
							<xsl:copy-of select="." copy-namespaces="yes"/>
						</xsl:if>
						<xsl:if test="ancestor::root/@ns=$ns">
							<!-- this will get the default xmlns @ -->
							<xsl:copy-of select="." copy-namespaces="yes"/>
						</xsl:if>
					</xsl:for-each-group>
					<xsl:for-each-group select="$output/root[@ns=$ns]/wsdl:definitions/namespace::node()" group-by="name(.)">
						<xsl:copy-of select="." copy-namespaces="yes"/>
					</xsl:for-each-group>
					<!-- this next copy gets elementFormDefault stuff and targetns 
it seems we need this following copy-of as well as the preceeding foreachgroup in order to get default @ etc
-->
					<xsl:copy-of select="wsdl:definitions/@*" copy-namespaces="yes"/>
					<wsdl:types>
						<xsl:variable name="wsdl-typesRoot">
							<xsl:for-each-group select="//xsd:schema" group-by="@targetNamespace">
								<xsl:apply-templates select="." mode="fileRelationMapping">
									<xsl:with-param name="contextBasePath">
										<xsl:value-of select="$sourceBasePath"/>
									</xsl:with-param>
									<xsl:with-param name="contextPathAndFileName">
										<xsl:value-of select="$sourcePathAndFileName"/>
									</xsl:with-param>
									<xsl:with-param name="contextNS">
										<xsl:value-of select="@targetNamespace"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:for-each-group>
							<!-- this next foreach is ONLY for no targetnamespace files but it hasn't been tested !!!!!>
							-->
							<xsl:for-each select="//xsd:schema[not(@targetNamespace)]">
								<xsl:apply-templates select="." mode="fileRelationMapping">
									<xsl:with-param name="contextBasePath">
										<xsl:value-of select="$sourceBasePath"/>
									</xsl:with-param>
									<xsl:with-param name="contextPathAndFileName">
										<xsl:value-of select="$sourcePathAndFileName"/>
									</xsl:with-param>
									<xsl:with-param name="contextNS">
										<xsl:value-of select="@targetNamespace"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="xsdFileMappingForResult">
							<xsl:apply-templates select="$wsdl-typesRoot/file" mode="fileRelationMappingFinal"/> 
						</xsl:variable>
						<xsl:variable name="xsdFileMappingRoot-Final">
							<xsl:for-each select="$xsdFileMappingForResult/file">
								<file type="root" ns="{@ns}" name="wsdlgenerateOutput" name2="xsdFileMappingRoot-Final">
									<name>
										<xsl:value-of select="name"/>
									</name>
									<xsl:variable name="rootns">
										<xsl:value-of select="@ns"/>
									</xsl:variable>
									<xsl:variable name="rootname">
										<xsl:value-of select="name"/>
									</xsl:variable>
									<xsl:for-each-group select=".//file[@ns=$rootns]" group-by="name">
										<file type="include" ns="{@ns}">
											<name>
												<xsl:value-of select="name"/>
											</name>
										</file>
									</xsl:for-each-group>
									<xsl:for-each-group select=".//file[@ns!=$rootns]" group-by="@ns">
										<xsl:variable name="ns">
											<xsl:value-of select="@ns"/>
										</xsl:variable>
										<xsl:for-each-group select="current-group()" group-by="name">
											<xsl:variable name="name">
												<xsl:value-of select="name"/>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="$xsdFileMappingForResult//file[@ns=$ns][file/name=$name]"> </xsl:when>
												<xsl:when test="@ns=$ns">
													<file type="import" ns="{@ns}">
														<name>
															<xsl:value-of select="name"/>
														</name>
													</file>
												</xsl:when>
												<xsl:otherwise/>
											</xsl:choose>
										</xsl:for-each-group>
									</xsl:for-each-group>
								</file>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="xsdFileMappingEachNS-Final">
							<xsl:for-each select="$xsdFileMappingRoot-Final//file[@type='import']">
								<file type="root" ns="{@ns}" name="wsdlgenerateOutput" name2="xsdFileMappingEachNS-Final">
									<name>
										<xsl:value-of select="name"/>
									</name>
									<xsl:variable name="rootns">
										<xsl:value-of select="@ns"/>
									</xsl:variable>
									<xsl:variable name="rootname">
										<xsl:value-of select="name"/>
									</xsl:variable>
									<xsl:for-each-group select="$xsdFileMappingForResult//file[name=$rootname]//file[@ns=$rootns]" group-by="name">
										<file type="include" ns="{@ns}" name="wsdlgenerateOutput">
											<name>
												<xsl:value-of select="name"/>
											</name>
										</file>
									</xsl:for-each-group>
									<xsl:for-each-group select="$xsdFileMappingForResult//file[name=$rootname]//file[@ns!=$rootns]" group-by="@ns">
										<xsl:variable name="ns">
											<xsl:value-of select="@ns"/>
										</xsl:variable>
										<xsl:for-each-group select="current-group()" group-by="name">
											<xsl:variable name="name">
												<xsl:value-of select="name"/>
											</xsl:variable>
											<file type="import" ns="{@ns}" name="wsdlgenerateOutput">
												<name>
													<xsl:value-of select="name"/>
												</name>
											</file>
										</xsl:for-each-group>
									</xsl:for-each-group>
								</file>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="thisns">
							<xsl:for-each-group select="./namespace::node()" group-by="name(.)">
								<xsl:if test=".=//xsd:schema/@targetNamespace and name(.)!=''">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each-group>
						</xsl:variable>
						<xsl:call-template name="generateOutput">
							<xsl:with-param name="theOutput">
								<master name="generateOutput">
									<xsl:copy-of select="$xsdFileMappingRoot-Final"/>
									<!-- zzz is this even necessary ??? -->
									<xsl:copy-of select="$xsdFileMappingEachNS-Final"/>
								</master>
							</xsl:with-param>
						</xsl:call-template>
					</wsdl:types>
					<xsl:for-each-group select="//wsdl:definitions/wsdl:message" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="yes"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="//wsdl:definitions/wsdl:portType" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="yes"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="//wsdl:definitions/wsdl:binding" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="yes"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="//wsdl:definitions/wsdl:service" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="yes"/>
					</xsl:for-each-group>
				</wsdl:definitions>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
	<!--
NOTE: these templates are very similar to SchemaFlattener.xslt
They are included here with slight alterations for this usage.

<xsl:template match="//xsd:schema" mode="fileRelationMapping">
<xsl:template name="generateOutput">

-->

	<!-- ******************************** 
  match="//xsd:schema" mode="fileRelationMapping"   
 ******************************** -->
	<xsl:template match="//xsd:schema" mode="fileRelationMapping">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="contextPathAndFileName"/>
		<xsl:param name="schemaLocationStringRecursionCheck"/>
		<xsl:variable name="nsdefault">
			<!-- only for xsd, not inhereted from wsdl root -->
			<xsl:for-each-group select="namespace::node()" group-by="name(.)">
				<xsl:if test="name(.)='' and .!='http://schemas.xmlsoap.org/wsdl/'">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="nstargetNamespace">
			<xsl:value-of select="@targetNamespace"/>
		</xsl:variable>
		<xsl:variable name="ns">
			<xsl:choose>
				<xsl:when test="$nsdefault!=''">
					<xsl:value-of select="$nsdefault"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nstargetNamespace"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<file type="root" ns="{$ns}" match="//xsd:schema" mode="fileRelationMapping">
			<name>
				<xsl:value-of select="$contextPathAndFileName"/>
			</name>
			<xsl:variable name="inscopeprefixes" select="in-scope-prefixes(.)"/>
			<xsl:element name="nsprefixesinscope" inherit-namespaces="yes">
				<xsl:value-of select="$inscopeprefixes"/>
			</xsl:element>
			<ns>
				<xsl:variable name="thisnode" select="."/>
				<xsl:for-each select="$inscopeprefixes">
					<xsl:variable name="this" select="."/>
					<xsl:attribute name="_{.}"><xsl:value-of select="namespace-uri-for-prefix($this,$thisnode)"/></xsl:attribute>
				</xsl:for-each>
			</ns>
			
			<xsl:for-each select="xsd:include | xsd:import">
				<xsl:call-template name="fileRelationMappingIncludes">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="$contextBasePath"/>
					</xsl:with-param>
					<xsl:with-param name="contextPathAndFileName">
						<xsl:value-of select="$contextPathAndFileName"/>
					</xsl:with-param>
					<xsl:with-param name="schemaLocationStringRecursionCheck">
						<xsl:value-of select="$schemaLocationStringRecursionCheck"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</file>
	</xsl:template>

	<!-- ******************************** 
  generateOutput   
 ******************************** -->
	<xsl:template name="generateOutput">
		<xsl:param name="theOutput"/>
		<xsl:variable name="output">
			<xsl:for-each select="$theOutput//file[@type='root'][not(contains(name,'.wsdl'))]">
				<xsl:variable name="filename">
					<xsl:value-of select="tokenize(name,'/')[last()]"/>
				</xsl:variable>
				<xsl:variable name="ns">
					<xsl:value-of select="@ns"/>
				</xsl:variable>
				<xsl:variable name="name">
					<xsl:value-of select="name"/>
				</xsl:variable>
				<root filename="{$filename}" ns="{$ns}" name="generateOutput">
					<xsl:for-each select="document(name)//xsd:schema">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="*[name()!='xsd:import'][name()!='xsd:include']"/>
							<xsl:for-each select="$theOutput//file[@type='root'][name=$name]//file[@type='include' or @type='root']">
								<xsl:value-of select="name"/>
								<xsl:value-of select="@type"/>
								<!-- this only seems to get noun and BOD.xsd trees but nothing else  -->
								<xsl:copy-of select="document(name)/xsd:schema/*[name()!='xsd:import'][name()!='xsd:include']"/>
							</xsl:for-each>
						</xsl:copy>
					</xsl:for-each>
				</root>
			</xsl:for-each>
			<!-- do same thing for wsdl schemas -->
			<xsl:for-each select="$theOutput//file[@type='root'][contains(name,'.wsdl')][1]">
				<xsl:variable name="thisfile">
					<xsl:value-of select="."/>
				</xsl:variable>
				<xsl:variable name="filename">
					<xsl:value-of select="tokenize(name,'/')[last()]"/>
				</xsl:variable>
				<xsl:variable name="name">
					<xsl:value-of select="name"/>
				</xsl:variable>
				<xsl:for-each select="document(name)//xsd:schema">
					<xsl:variable name="ns">
						<xsl:value-of select="@targetNamespace"/>
					</xsl:variable>
					<root filename="{$filename}" ns="{@targetNamespace}" name="generateOutput">
						<xsl:comment>
							<xsl:value-of select="$filename"/>
						</xsl:comment>
						<xsl:copy>
							<!-- this copy of ns node is to get the default namespace copied to result tree.
otherwise it takes the default ns of the wsdl which is not correct.-->
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="*[local-name()!='import'][name()!='include']"/>
							<xsl:for-each select="$theOutput//file[@type='root'][name=$name]//file[@type='include'][@ns=$ns]">
								<xsl:copy-of select="document(name)/xsd:schema/*[name()!='xsd:import'][name()!='xsd:include']"/>
							</xsl:for-each>
						</xsl:copy>
					</root>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="filename">
			<xsl:value-of select="@filename"/>
		</xsl:variable>
		<xsl:variable name="ns">
			<xsl:value-of select="@ns"/>
		</xsl:variable>
		<xsl:for-each-group select="$output//xsd:schema" group-by="@targetNamespace">
				<xsd:schema>
				<xsl:for-each-group select="namespace::node()" group-by="name()">
					<xsl:sort order="ascending" select="name()"/>
					<xsl:copy-of select="." copy-namespaces="yes"/>
				</xsl:for-each-group>
				<xsl:variable name="tns" select="@targetNamespace"/>
				<!-- 
					this is a problem for xsd flattener but since we aren't flattening schemas
					but simply copying them into wsdl, not a problem here:
					
					<xsl:variable name="inscopeprefixes" select="in-scope-prefixes(.)"/>
					<xsl:element name="nsprefixesinscope" inherit-namespaces="yes">
					<xsl:value-of select="$inscopeprefixes"/>
					</xsl:element>
					<ns>
					<xsl:variable name="thisnode" select="."/>
					<xsl:for-each select="$inscopeprefixes">
					<xsl:variable name="this" select="."/>
					<xsl:attribute name="_{.}"><xsl:value-of select="namespace-uri-for-prefix($this,$thisnode)"/></xsl:attribute>
					</xsl:for-each>
					</ns>
				-->
				<xsl:for-each select="$output//xsd:schema[@targetNamespace=$tns]">
					<!-- this goes and fetches child include namespace declarations -->
					<xsl:for-each-group select=".//namespace::node()" group-by="name()">
						<xsl:sort order="ascending" select="name()"/>
						<xsl:if test="name(.)!='targetNamespace' and name(.)!=''">
							<xsl:copy-of select="." copy-namespaces="yes"/>
						</xsl:if>
					</xsl:for-each-group>
					
					<!-- this next copy gets elementFormDefault stuff and targetns 
it seems we need this following copy-of as well as the preceeding foreachgroup in order to get default @ etc
-->
				</xsl:for-each>
				<xsl:copy-of select="@*" copy-namespaces="yes"/>
				<xsl:for-each-group select="$output//xsd:schema[@targetNamespace=$tns]/xsd:element" group-by="@name">
					<xsl:copy-of select="." copy-namespaces="yes"/>
				</xsl:for-each-group>
				<xsl:for-each-group select="$output//xsd:schema[@targetNamespace=$tns]/xsd:attribute" group-by="@name">
					<xsl:copy-of select="." copy-namespaces="yes"/>
				</xsl:for-each-group>
				<xsl:for-each-group select="$output//xsd:schema[@targetNamespace=$tns]/xsd:simpleType" group-by="@name">
					<xsl:copy-of select="." copy-namespaces="yes"/>
				</xsl:for-each-group>
				<xsl:for-each-group select="$output//xsd:schema[@targetNamespace=$tns]/xsd:complexType" group-by="@name">
					<xsl:copy-of select="." copy-namespaces="yes"/>
				</xsl:for-each-group>
				<xsl:for-each-group
					select="$output//xsd:schema[@targetNamespace=$tns]/xsd:group | $output//xsd:schema[@targetNamespace=$tns]/xsd:attributeGroup"
					group-by="@name">
					<xsl:copy-of select="." copy-namespaces="yes"/>
				</xsl:for-each-group>
			</xsd:schema>
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>

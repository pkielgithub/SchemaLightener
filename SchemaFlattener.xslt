<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************

XSLT name:    SchemaFlattener.xslt

Version:  4.9

Date: 2016-01-18

Purpose:  This stylesheet merges all xsd:includes into a single schema.  It also takes each xsd:import and merges each of its xsd:includes as well, assigning paths as needed.  

Notes:  This stylesheet grew out of an original requirement for Xslt 1.0 technology only.  It has since been significantly improved using Xslt 2.0 and will continue to develop beyond the initial 1.0 requirement.  


2010-02-20:
- fixed different paths to same xsd problem.  
2014-05-24
- In a situation where an xsd:import does not contain a @schemaLocation, you may 
get valid results but also an error thrown as the parser tries to locate the schema via the namespace.
An IF statement tells the process to NOT import xsd:imports with no @schemaLocation.
since any imports are included in the wsdl itself, this should resolve the error and still give good results.
2016-01-18
- minor updates

**********************************************************************
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="fn " xmlns="">
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no"/>
	<xsl:include href="common.xslt"/>
	<xsl:include href="directories.xslt"/>
	<!--
Parameters:
  
sourcePathAndFileName: This is the name and full path of the Xml Schema that is to be flattened.  

resultBasePath:  This is the path to a folder where the results of the transformation will be placed.  
Make sure permissions are set at this location so the transformation can be created properly.

Notes on parameters and XSLT processors:
1.  Some XSLT processors require "file:///" to precede a full drive or network path, e.g.

	<xsl:param name="sourcePathAndFileName">file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>

A relative path does not require the "file:///" to precede it.
2.  Some XSLT processors will not work well with back slashes "\" and so forward slashes "/" are recommended.
3.  Some XSLT processors may need trailing forward slash "/" to correctly create the result, as in:

	<xsl:param name="resultBasePath">file:///c:/xmlschemas/lightened/result/</xsl:param>

The trailing forward slash is therefore recommended.


-->
	<xsl:param name="resultBasePath"/>
	<xsl:variable name="sourcePathAndFileName">
		<xsl:choose>
			<xsl:when test="function-available('document-uri')">
				<xsl:value-of select="document-uri(.)"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
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
		<xsl:variable name="FileMappingAsIs">
			<!-- list of file includes and imports as they exist in the original (meaning including duplicates) -->
			<xsl:apply-templates select="xsd:schema" mode="fileRelationMapping">
				<xsl:with-param name="contextBasePath">
					<xsl:value-of select="$sourceBasePath"/>
				</xsl:with-param>
				<xsl:with-param name="contextPathAndFileName">
					<xsl:value-of select="$sourcePathAndFileNameTranslated"/>
				</xsl:with-param>
				<!-- in-scope-prefixes() and  namespace-uri-for-prefix(). -->
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="FileMappingForResult">
			<!-- list of files with imports and includes organized with no duplicates -->
			<xsl:apply-templates select="$FileMappingAsIs/file" mode="fileRelationMappingFinal"> </xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="FileMappingRoot-Final">
			<!-- final list of files with imports and includes for root schema only (and no duplicates) -->
			<xsl:for-each select="$FileMappingForResult/file">
				<file type="root" ns="{@ns}">
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
						<!-- includes -->
						<file type="include" ns="{@ns}">
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
								<xsl:when test="$FileMappingForResult//file[@ns=$ns][file/name=$name]">
									<!-- its included in another file -->
								</xsl:when>
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
		<xsl:variable name="FileMappingEachNS-Final">
			<!-- now let's create a file list for each NS, again no dupes -->
			<xsl:for-each select="$FileMappingRoot-Final//file[@type='import']">
				<file type="root" ns="{@ns}">
					<name>
						<xsl:value-of select="name"/>
					</name>
					<xsl:variable name="rootns">
						<xsl:value-of select="@ns"/>
					</xsl:variable>
					<xsl:variable name="rootname">
						<xsl:value-of select="name"/>
					</xsl:variable>
					<xsl:for-each-group select="$FileMappingForResult//file[name=$rootname]//file[@ns=$rootns]" group-by="name">
						<!-- includes -->
						<file type="include" ns="{@ns}">
							<name>
								<xsl:value-of select="name"/>
							</name>
						</file>
					</xsl:for-each-group>
					<xsl:for-each-group select="$FileMappingForResult//file[name=$rootname]//file[@ns!=$rootns]" group-by="@ns">
						<!-- imports -->
						<xsl:variable name="ns">
							<xsl:value-of select="@ns"/>
						</xsl:variable>
						<xsl:for-each-group select="current-group()" group-by="name">
							<xsl:variable name="name">
								<xsl:value-of select="name"/>
							</xsl:variable>
							<file type="import" ns="{@ns}">
								<name>
									<xsl:value-of select="name"/>
								</name>
							</file>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</file>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="generateOutput">
			<xsl:with-param name="theOutput">
				<master>
					<xsl:copy-of select="$FileMappingRoot-Final"/>
					<!-- root file list -->
					<xsl:copy-of select="$FileMappingEachNS-Final"/>
					<!-- list of each import as a root -->
				</master>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ******************************** 
  match="//xsd:schema" mode="fileRelationMapping"   
 ******************************** -->
	<xsl:template match="//xsd:schema" mode="fileRelationMapping">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="contextPathAndFileName"/>
		<xsl:param name="schemaLocationStringRecursionCheck"/>
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
			<xsl:for-each select="$theOutput//file[@type='root']">
				<xsl:variable name="filename">
					<xsl:choose>
						<xsl:when test="starts-with(name,'http')">
								<xsl:choose>
									<xsl:when test="contains(name,'://')">
										<xsl:value-of select="translate(substring-after(name,'://'),'#\/*?:|','_______')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="translate(name,'#\/*?:|','_______')"/>
									</xsl:otherwise>
								</xsl:choose>
							
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="tokenize(name,'/')[last()]"/></xsl:otherwise>
					</xsl:choose>
					
				</xsl:variable>
				<xsl:variable name="ns">
					<xsl:value-of select="@ns"/>
				</xsl:variable>
				<xsl:variable name="name">
					<xsl:value-of select="name"/>
				</xsl:variable>
				<root filename="{$filename}" ns="{$ns}" name="generateOutput">
					<xsl:for-each select="document(name)/xsd:schema">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:for-each select="$theOutput//file[@type='root'][name=$name]//file[@type='import']">
								<xsl:variable name="thisns">
									<xsl:value-of select="@ns"/>
								</xsl:variable>
								<xsl:variable name="thisfilename">
									<xsl:choose>
										<xsl:when test="starts-with(name,'http')">
											<xsl:choose>
												<xsl:when test="contains(name,'://')">
													<xsl:value-of select="translate(substring-after(name,'://'),'#\/*?:|','_______')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="translate(name,'#\/*?:|','_______')"/>
												</xsl:otherwise>
											</xsl:choose>
											
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="tokenize(name,'/')[last()]"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="thisname">
									<xsl:value-of select="name"/>
								</xsl:variable>
								<xsl:variable name="nsAsFolderName">
									<xsl:choose>
										<xsl:when test="contains($thisns,'://')">
											<xsl:value-of select="translate(substring-after($thisns,'://'),'#\/*?:|','_______')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate($thisns,'#\/*?:|','_______')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="@type='import' and $theOutput//file[@type='root'][not(name=$thisname)]//file[@type='include'][ends-with(name,$thisfilename)][@ns=$thisns]">
										<!-- do nothing.  it is an import that is an include of another file, which it will be flattened into -->
									</xsl:when>
									<xsl:when test="$ns=''">
										<!-- the parent root is no NS, so it won't be put into a folder
										therefore we don't want ../ references in the imports-->
										<xsd:import namespace="{@ns}" schemaLocation="{$nsAsFolderName}/{$thisfilename}"/>
									</xsl:when>
									<xsl:otherwise>
										<xsd:import namespace="{@ns}" schemaLocation="../{$nsAsFolderName}/{$thisfilename}"/>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:for-each>
							<xsl:copy-of select="*[local-name()!='import'][name()!='include']"/>
							<xsl:for-each select="$theOutput//file[@type='root'][name=$name]//file[@type='include']">
								<xsl:copy-of select="document(name)/xsd:schema/*[local-name()!='import'][name()!='include']"/>
							</xsl:for-each>
						</xsl:copy>
					</xsl:for-each>
				</root>
			</xsl:for-each>
		</xsl:variable>

		<xsl:for-each-group select="$output/root" group-by="@ns">
			<xsl:variable name="filename">
				<xsl:value-of select="@filename"/>
			</xsl:variable>
			<xsl:variable name="ns">
				<xsl:value-of select="@ns"/>
			</xsl:variable>
			<xsl:variable name="nsAsFolderName">
				<xsl:choose>
					<xsl:when test="contains($ns,'://')">
						<xsl:value-of select="translate(substring-after($ns,'://'),'#\/*?:|','_______')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate($ns,'#\/*?:|','_______')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:result-document href="{$resultBasePathTranslated}{$nsAsFolderName}/{@filename}">
				<xsd:schema>
					
					<xsl:for-each-group select=".//xsd:schema//namespace::node()" group-by="name(.)">
						<!-- first get ns for this schema -->
						<xsl:if test="name(.)!='targetNamespace' and name(.)!=''">
							<xsl:copy-of select="." copy-namespaces="yes"/>
						</xsl:if>
						<xsl:if test="ancestor::root/@ns=$ns">
							<!-- this will get the default xmlns @ -->
							<xsl:copy-of select="." copy-namespaces="yes"/>
						</xsl:if>
					</xsl:for-each-group>
					
	
					<!-- this next copy gets elementFormDefault stuff and targetns 
it seems we need this following copy-of as well as the preceeding foreachgroup in order to get default @ etc
-->
					<xsl:copy-of select="xsd:schema/@*" copy-namespaces="yes"/>
					<xsl:for-each select="xsd:schema/xsd:import">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each>
					<xsl:for-each-group select="xsd:schema/xsd:element" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="xsd:schema/xsd:attribute" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="xsd:schema/xsd:simpleType" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="xsd:schema/xsd:complexType" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="xsd:schema/xsd:group | xsd:schema/xsd:attributeGroup" group-by="@name">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each-group>
				</xsd:schema>
			</xsl:result-document>
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>

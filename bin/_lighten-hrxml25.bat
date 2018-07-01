::  
:: lighten-hrxml25.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, HR-XML version 2_5. 
:: 
:: syntax:
:: 
::echo java -jar saxon9.jar [source XSD path] [stylesheet] instanceFilePathAndName=[xml instance path] resultBasePath=[result path]  
::java -jar saxon9.jar [source XSD path] [stylesheet] instanceFilePathAndName=[xml instance path] resultBasePath=[result path] 
::
::
:: Parameters:
:: instanceFilePathAndName - full or relative path to representative xml instance document.
:: resultBasePath - full or relative path to directory where result should be placed. Make sure permissions are set to allow this.
::
:: Notes on parameters and XSLT processors:
:: 1. Some XSLT processors require "file:///" to precede a full drive or network path, e.g.
:: 
:: 	<xsl:param name="instanceFilePathAndName">file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>
:: 
:: 2. Some XSLT processors will not work well with back slashes "\" and so forward slashes "/" are recommended.
:: 3. Some XSLT processors may need a trailing forward slash "/" to correctly create the result folder, as in:
:: 
:: 	<xsl:param name="resultBasePath">file:///c:/xmlschemas/lightened/result/</xsl:param>
::
:: The trailing forward slash is therefore recommended.
::
SET logfile=results/output-lighten-hrxml25.txt
SET errorlogfile=%logfile%.errors.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCancelRequest.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCancelRequest.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCancelRequest/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCancelRequest.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCancelRequest.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCancelRequest/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalog.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalog.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalog/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalog.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalog.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalog/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalog.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalog2.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalog2/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalog.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalog2.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalog2/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalog.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalog3.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalog3/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalog.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalog3.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalog3/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalogQuery.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalogQuery.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalogQuery/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalogQuery.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalogQuery.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalogQuery/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalogQuery.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalogQuery2.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalogQuery2/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentCatalogQuery.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentCatalogQuery2.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentCatalogQuery2/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentOrderRequest.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentOrderRequest.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentOrderRequest/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentOrderRequest.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentOrderRequest.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentOrderRequest/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentResult.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentResult.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentResult/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentResult.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentResult.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentResult/ 1>>%logfile% 2>>%errorlogfile%


echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentStatusRequest.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentStatusRequest.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentStatusRequest/ rootElement="AssessmentStatusRequest" 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentStatusRequest.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentStatusRequest.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentStatusRequest/ rootElement="AssessmentStatusRequest" 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentOrderAcknowledgement.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentOrderAcknowledgement.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentOrderAcknowledgement/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentOrderAcknowledgement.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentOrderAcknowledgement.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentOrderAcknowledgement/ 1>>%logfile% 2>>%errorlogfile%


echo java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentOrderAcknowledgement.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentOrderAcknowledgement.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentOrderAcknowledgement/ rootElement="AssessmentOrderAcknowledgement" 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/hr-xml/HR-XML-2_5/StandAlone/AssessmentOrderAcknowledgement.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/hr-xml/HR-XML-2_5/instances/AssessmentOrderAcknowledgement.xml resultBasePath=results/temp-lighten-hrxml25/AssessmentOrderAcknowledgement/ rootElement="AssessmentOrderAcknowledgement" 1>>%logfile% 2>>%errorlogfile%

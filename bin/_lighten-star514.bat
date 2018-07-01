:: 
:: lighten-star514.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, STAR version 5.1.4. 
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
SET logfile=results/output-lighten-star514.txt
SET errorlogfile=%logfile%.errors.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeCreditApplication.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeCreditApplication.xml resultBasePath=results/temp-lighten-star514/AcknowledgeCreditApplication/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeCreditApplication.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeCreditApplication.xml resultBasePath=results/temp-lighten-star514/AcknowledgeCreditApplication/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeCreditContractResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeCreditContractResponse.xml resultBasePath=results/temp-lighten-star514/AcknowledgeCreditContractResponse/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeCreditContractResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeCreditContractResponse.xml resultBasePath=results/temp-lighten-star514/AcknowledgeCreditContractResponse/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeCreditDecision.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeCreditDecision.xml resultBasePath=results/temp-lighten-star514/AcknowledgeCreditDecision/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeCreditDecision.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeCreditDecision.xml resultBasePath=results/temp-lighten-star514/AcknowledgeCreditDecision/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeFinancialStatement.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeFinancialStatement.xml resultBasePath=results/temp-lighten-star514/AcknowledgeFinancialStatement/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeFinancialStatement.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeFinancialStatement.xml resultBasePath=results/temp-lighten-star514/AcknowledgeFinancialStatement/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeLaborOperations.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeLaborOperations.xml resultBasePath=results/temp-lighten-star514/AcknowledgeLaborOperations/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgeLaborOperations.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgeLaborOperations.xml resultBasePath=results/temp-lighten-star514/AcknowledgeLaborOperations/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsActivity.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsActivity.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsActivity/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsActivity.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsActivity.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsActivity/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsInventory.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsInventory.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsInventory/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsInventory.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsInventory.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsInventory/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsInvoice.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsInvoice.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsInvoice/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsInvoice.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsInvoice.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsInvoice/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsMaster.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsMaster.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsMaster/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsMaster.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsMaster.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsMaster/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsOrder.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsOrder.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsOrder/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Standalone/AcknowledgePartsOrder.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/star/Rev5.1.4/BODExamples/AcknowledgePartsOrder.xml resultBasePath=results/temp-lighten-star514/AcknowledgePartsOrder/ 1>>%logfile% 2>>%errorlogfile%

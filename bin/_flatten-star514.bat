:: 
:: flatten-star514.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, STAR version 5.1.4. 
:: 
:: syntax:
:: 
::echo java -jar saxon9.jar [-o output file (optional)] [source XSD path] [stylesheet] resultBasePath=[result path]  
::java -jar saxon9.jar [-o output file (optional)] [source XSD path] [stylesheet] resultBasePath=[result path] 
::
::
:: Parameters:
:: resultBasePath - full or relative path to directory where result should be placed. Make sure permissions are set to allow this.
::
:: Notes on parameters and XSLT processors:
:: 1. Some XSLT processors require file:/// to precede a full drive or network path, e.g.
:: 
:: <xsl:param name=instanceFilePathAndName>file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>
:: 
:: 2. Some XSLT processors will not work well with back slashes \ and so forward slashes / are recommended.
:: 3. Some XSLT processors may need a trailing forward slash / to correctly create the result folder, as in:
:: 
:: <xsl:param name=resultBasePath>file:///c:/xmlschemas/lightened/result/</xsl:param>
::
:: The trailing forward slash is therefore recommended.
:: 
SET errorlogfile=results/output-flatten-star514-errors.txt
SET logfile=results/output-flatten-star514.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeCreditApplication.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeCreditApplication.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeCreditContractResponse.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeCreditContractResponse.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeCreditDecision.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeCreditDecision.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeFinancialStatement.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeFinancialStatement.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeLaborOperations.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgeLaborOperations.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsActivity.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsActivity.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsInventory.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsInventory.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsInvoice.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsInvoice.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsMaster.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsMaster.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsOrder.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/STAR/Rev5.1.4/BODs/Developer/AcknowledgePartsOrder.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-star514/ 1>>%logfile% 2>>%errorlogfile%

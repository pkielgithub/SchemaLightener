:: 
:: wsdl-flatten-hrxml3.bat
:: 
:: This batch file is used to apply the WSDL Flattener xslt to multiple source  files. In this case, hrxml3. 
:: 
:: syntax:
:: 
::echo java -jar saxon9.jar [-o output file (optional)] [source XSD path] [stylesheet]  resultBasePath=[result path]  
::java -jar saxon9.jar [-o output file (optional)] [source XSD path] [stylesheet]  resultBasePath=[result path] 
::
::
:: Parameters:
:: resultBasePath - full or relative path to directory where result should be placed.  Make sure permissions are set to allow this.
::
:: Notes on parameters and XSLT processors:
:: 1. Some XSLT processors require file:/// to precede a full drive or network path,  e.g.
:: 
:: <xsl:param  name=instanceFilePathAndName>file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>
:: 
:: 2. Some XSLT processors will not work well with back slashes / and so forward  slashes / are recommended.
:: 3. Some XSLT processors may need a trailing forward slash / to correctly create the  result folder, as in:
:: 
:: <xsl:param name=resultBasePath>file:///c:/xmlschemas/lightened/result/</xsl:param>
::
:: The trailing forward slash is therefore recommended.
::
REM the default namespace ***xmlns="http://www.hr-xml.org/3"*** was added to the source WSDL files' xsd:schema element.

SET logfile=results/output-wsdl-flatten-hrxml3.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar  ../SampleData/hr-xml/HR-XML-3_0/org_hr-xml/3_0/Services/Web_Services/WSDL/AssessmentCatalog.wsdl  ../WSDLFlattener.xslt resultBasePath=results/temp-wsdl-flatten-hrxml3/1/ 2>>%logfile% 
java -jar saxon9.jar  ../SampleData/hr-xml/HR-XML-3_0/org_hr-xml/3_0/Services/Web_Services/WSDL/AssessmentCatalog.wsdl  ../WSDLFlattener.xslt resultBasePath=results/temp-wsdl-flatten-hrxml3/1/ 2>>%logfile%


echo java -jar saxon9.jar  ../SampleData/hr-xml/HR-XML-3_0/org_hr-xml/3_0/Services/Web_Services/WSDL/AssessmentOrder.wsdl  ../WSDLFlattener.xslt resultBasePath=results/temp-wsdl-flatten-hrxml3/2/ 2>>%logfile% 
java -jar saxon9.jar  ../SampleData/hr-xml/HR-XML-3_0/org_hr-xml/3_0/Services/Web_Services/WSDL/AssessmentOrder.wsdl  ../WSDLFlattener.xslt resultBasePath=results/temp-wsdl-flatten-hrxml3/2/ 2>>%logfile%


echo java -jar saxon9.jar  ../SampleData/hr-xml/HR-XML-3_0/org_hr-xml/3_0/Services/Web_Services/WSDL/AssessmentReport.wsdl  ../WSDLFlattener.xslt resultBasePath=results/temp-wsdl-flatten-hrxml3/3/ 2>>%logfile% 
java -jar saxon9.jar  ../SampleData/hr-xml/HR-XML-3_0/org_hr-xml/3_0/Services/Web_Services/WSDL/AssessmentReport.wsdl  ../WSDLFlattener.xslt resultBasePath=results/temp-wsdl-flatten-hrxml3/3/ 2>>%logfile%


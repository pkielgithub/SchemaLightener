:: 
:: lighten-twist31.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, TWIST version 3.1. 
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
::
::
SET xslt=../SchemaLightener.xslt 
SET logfile=results/output-lighten-twist31.txt
SET errorlogfile=%logfile%.errors.txt
SET result=results/temp-lighten-twist31/

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1Billing.ElectronicBillingMsgOnlyMandatoryElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1Billing.ElectronicBillingMsgOnlyMandatoryElements/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1Billing.ElectronicBillingMsgOnlyMandatoryElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1Billing.ElectronicBillingMsgOnlyMandatoryElements/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleDetailAccount22-333-44TaxesDue.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleDetailAccount22-333-44TaxesDue/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleDetailAccount22-333-44TaxesDue.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleDetailAccount22-333-44TaxesDue/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleDetailAccount32-888-0NoTaxesDue.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleDetailAccount32-888-0NoTaxesDue/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleDetailAccount32-888-0NoTaxesDue.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleDetailAccount32-888-0NoTaxesDue/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleRelationshipParentAccountINT5555.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleRelationshipParentAccountINT5555/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleRelationshipParentAccountINT5555.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleRelationshipParentAccountINT5555/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleXMLSpyGeneratedInclOptionalElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleXMLSpyGeneratedInclOptionalElements/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.Billing.TwistMsgElectronicBilling.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1BSBSampleXMLSpyGeneratedInclOptionalElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1BSBSampleXMLSpyGeneratedInclOptionalElements/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationInclOptionalElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationInclOptionalElements/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationInclOptionalElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationInclOptionalElements/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationOnlyMandatoryElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationOnlyMandatoryElements/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationOnlyMandatoryElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestCancellationOnlyMandatoryElements/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestInclOptionalElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestInclOptionalElements/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestInclOptionalElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestInclOptionalElements/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestOnlyMandatoryElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestOnlyMandatoryElements/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/twist/schemas/TWIST3.1.FinancialSupplyChain.TwistMsgSupplyChain.200609.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/twist/xml/TWIST3.1FinancialSupplyChain.FinanceRequestOnlyMandatoryElements.xml resultBasePath=results/temp-lighten-twist31/TWIST3.1FinancialSupplyChain.FinanceRequestOnlyMandatoryElements/ 1>>%logfile% 2>>%errorlogfile%

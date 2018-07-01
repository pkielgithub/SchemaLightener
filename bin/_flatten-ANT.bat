:: 
:: flatten-ANT.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. 
:: 
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
../apache-ant-1.8.1/bin/ant -buildfile _flatten-ANT-build.xml -lib saxon9.jar 

 
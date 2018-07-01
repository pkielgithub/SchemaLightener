@echo off

:: executable jar
java -jar  "SchemaLightener.jar"

:: java with classpath if you prefer such
::java -cp .;lib/saxon9.jar;out/production/SchemaLightener/ SchemaLightener
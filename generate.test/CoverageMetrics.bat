@echo off

SET dotnet="C:/Program Files/dotnet/dotnet.exe"  
SET reportgenerator=D:\ReportGenerator_4.4.7\netcoreapp3.0\ReportGenerator.exe
SET historyDir=D:\OpenCoverHistory\generate

SET coveragefile="C:\Web\CodeCoverage\Generate\Coverage.xml"  
SET coveragedir="C:\Web\CodeCoverage\Generate"

REM Run code coverage analysis  
%dotnet% test --verbosity=normal --filter Category!=UserInterface /p:AltCover=true /p:AltCoverAssemblyExcludeFilter="xunit.*|generate.test|generate.test.UserInterface|FluentValidation"

REM Delete existing report / Move coverage file
del %coveragedir%\*.* /q
copy "generate.test\coverage.xml" %coveragefile%
del "generate.test\coverage.xml"

REM Generate the report  
%reportgenerator% -targetdir:%coveragedir% -reporttypes:Html;HtmlChart;Badges -reports:%coveragefile% -verbosity:Error -historydir:%historyDir%
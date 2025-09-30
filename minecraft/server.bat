@echo off
set curdir=%~dp0
:: constants
set min=-Xms1G
set max=-Xmx4G
set prefix=paper
::
for /f "delims=" %%f in ('dir /b *%prefix%*') do (
java %max% %min% -jar %%f
)
pause
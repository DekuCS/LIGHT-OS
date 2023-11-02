@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && exit /b 1



echo LIGHTOS: disabling cpu idle state..

powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
powercfg /setactive scheme_current

echo LIGHTOS: cpu idle state is now set to off

exit /b 0

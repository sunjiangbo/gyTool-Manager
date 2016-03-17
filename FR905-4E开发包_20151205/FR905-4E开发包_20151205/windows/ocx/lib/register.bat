set base_dir=%~dp0  
%base_dir:~0,2%  
pushd %base_dir%  
regsvr32.exe ModuleAPI.ocx /u /s
regsvr32.exe ModuleAPI.ocx
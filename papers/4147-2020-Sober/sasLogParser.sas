/* Macro variable for the path to sas log parser directory */
%let sasLogParser=C:\Users\sasss1\OneDrive - SAS\sasLogParser\;

/* Macro varialbe for the path containing the SAS Logs */
%let path2files=C:\Users\sasss1\OneDrive - SAS\sasLogParser\logs\;

%include "&sasLogParser.macros.sas";

%check(&sasLogParser.logfiles.txt);

proc printto log="&sasLogParser.logfiles.txt";
run;

%list_files(&path2files.,log);

proc printto;
run;

%check(&sasLogParser.includeCode.sas);

data _null_;
   length line pdfLine $100.;
   infile "&sasLogParser.logfiles.txt" truncover;
   file "&sasLogParser.includeCode.sas" ; 
   input line $100.;
   if substr(line,1,2) = "C:";
   findLog=length(trim(line));
   findLog2=findLog - 2;
   pdfLine=line;
   substr(pdfLine,findLog2,3)='pdf;';
   odsStatement="ods pdf file=";
   letStatement="%" || "let log1=";
   sasLogStatement="%" || "saslog(file=" || "&" || "log1,test=" || "&" || "test1);";
   statement1=odsStatement || '"' || trim(pdfLine) || '";';
   statement2=letStatement || trim(line) || ';';
   put statement1;
   put statement2;
   put sasLogStatement;
run;

proc delete data=work.logs;
run;

%let test1=SAS9Log;

ods noresults;
%include "&sasLogParser.includeCode.sas";

ods pdf file="&path2files.1.descendingRealTime.pdf"; 

proc sort data=work.logs;
   by descending realtime;
run;

proc print data=work.logs label;
   title "Descending Clock Time";
   var step realtime cputime totaltime totalcpu fileName;
run;

ods pdf file="&path2files.2.descendingCPUTime.pdf"; 

proc sort data=work.logs;
   by descending cputime;
run;

proc print data=work.logs Label;
   title "Descending CPU Time";
   var step realtime cputime totaltime totalcpu fileName;
run;

ods pdf close;

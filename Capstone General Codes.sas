/* Generated Code (IMPORT) */
/* Source File: HT_2013_2018.csv */
/* Source Path: /folders/myfolders/sasuser.v94/HT_2013-2018 */
/* Code generated on: 9/20/20, 9:43 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/folders/myfolders/sasuser.v94/HT_2013-2018/HT_2013_2018.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

PROC MEANS DATA=WORK.IMPORT;
TITLE 'GENERAL SUMMARY ON HUMAN TRAFFICKING DATA SET';
RUN;

PROC UNIVARIATE DATA=work.IMPORT;
TITLE 'DETAILED SUMMARY ON HUMNA TRAFFICKING DATA SET';
RUN;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.IMPORT;
	title height=14pt "State Actual Count of Recorded Cases per Year";
	scatter x=STATE_ABBR y=ACTUAL_COUNT / group=DATA_YEAR;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;
title;

PROC SQL;
CREATE TABLE WORK.query AS
SELECT DATA_YEAR , STATE_NAME , OFFENSE_SUBCAT_ID , ACTUAL_COUNT , CLEARED_COUNT FROM WORK.IMPORT;
RUN;
QUIT;

PROC DATASETS NOLIST NODETAILS;
CONTENTS DATA=WORK.query OUT=WORK.details;
RUN;

PROC PRINT DATA=WORK.details;
RUN;

PROC MEANS DATA=WORK.query;
Title 'Summary on Narrowed Table';
Run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.QUERY out=_SeriesPlotTaskData;
	by DATA_YEAR;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Count of Recorded Cases per Year";
	series x=DATA_YEAR y=ACTUAL_COUNT / lineattrs=(color=CXe4173d);
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.QUERY;
	title height=14pt 
		"Involuntary Servitude vs Commerical Sex Acts over the years";
	vbar DATA_YEAR / group=OFFENSE_SUBCAT_ID groupdisplay=cluster datalabel;
	yaxis grid;
run;

ods graphics / reset;
title;
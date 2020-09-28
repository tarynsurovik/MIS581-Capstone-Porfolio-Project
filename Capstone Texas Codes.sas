proc sql noprint;
	create table work.filter as select * from WORK.QUERY where(put(STATE_NAME, 
		$11.) EQ 'Texas');
Run;

PROC Means Data=Work.filter;
Title ' Summary Count of Actual Cases in Texas';
Run;

ods noproctitle;
ods graphics / imagemap=on;

/* Test for normality */
proc univariate data=WORK.FILTER normal mu0=0;
	ods select TestsForNormality;
	var ACTUAL_COUNT;
run;

/* t test */
proc ttest data=WORK.FILTER sides=2 h0=0 plots(showh0);
	var ACTUAL_COUNT;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.FILTER;
	title height=14pt "Summary of Acutal Count in Cases Per Year in Texas";
	vbar DATA_YEAR / response=ACTUAL_COUNT;
	yaxis grid;
run;

ods graphics / reset;
title;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FILTER out=_BarChartTaskData;
	by OFFENSE_SUBCAT_ID;
run;

proc sgplot data=_BarChartTaskData;
	by OFFENSE_SUBCAT_ID;
	title height=14pt "Summary of Subset Cases Per Year in Texas";
	footnote2 justify=left height=12pt 
		"ID 81 = Commerical Sex Acts; ID 82 = Involuntary Servitude";
	vbar DATA_YEAR / response=ACTUAL_COUNT;
	yaxis grid;
run;

ods graphics / reset;
title;
footnote2;

proc datasets library=WORK noprint;
	delete _BarChartTaskData;
	run;
	
	ods noproctitle;
ods graphics / imagemap=on;

proc sort data=WORK.FILTER out=Work.preProcessedData;
	by DATA_YEAR;
run;

proc arima data=Work.preProcessedData plots
    (only)=(series(corr crosscorr) residual(corr normal) 
		forecast(forecastonly));
	identify var=ACTUAL_COUNT (1 1);
	estimate noint method=CLS;
	forecast lead=12 back=0 alpha=0.05 id=DATA_YEAR interval=day;
	outlier;
	run;
quit;

proc delete data=Work.preProcessedData;
run;
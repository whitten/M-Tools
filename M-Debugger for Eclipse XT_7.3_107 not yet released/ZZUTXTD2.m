ZZUTXTD2	;OAKLAND-OIFO/JLI-UNIT TESTS FOR XTDEBUG - CONTINUATION ;11/8/07  13:13
	;;7.3;TOOLKIT;**???**;Apr 25, 1995
	D EN^XTMUNIT("ZZUTXTD2") ;1")
	Q
	;
ROULOAD	;
	N XTDEBLOC,ROULOC,XTDEBLO1,ZZLINNUM
	S XTDEBLOC=$$GETGLOB^XTDEBUG(),XTDEBLO1=$NA(@XTDEBLOC@("ROU")) K @XTDEBLOC
	S ROULOC=$$SETROU^XTDEBUG("ZZUTXTD1")
	S ZZLINNUM=$$LINENUM^XTDEBUG("ZZUTXTD1","OPENTAG")
	D CHKEQ^XTMUNIT($O(@XTDEBLO1@("B","ZZUTXTD1",0)),ROULOC,"Incorrect locator returned")
	D CHKEQ^XTMUNIT(@XTDEBLO1@(ROULOC,1,0),$T(+1^ZZUTXTD1),"First lines don't match")
	D CHKEQ^XTMUNIT($O(@XTDEBLO1@(ROULOC,"TAG","OPENTAG",0)),ZZLINNUM,"OPENTAG index doesn't match")
	Q
	;
ROUGLOB	;
	N ROUGLOB
	S ROUGLOB=$$ROUGLOB^XTDEBUG()
	D CHKEQ^XTMUNIT(ROUGLOB,$NA(^TMP("XTDEBUG",$J,"ROU")),"Wrong global location for routines")
	Q
	;
ROULOC	;
	N ROUGLOB
	S ROUGLOB=$$ROUGLOB^XTDEBUG() K @ROUGLOB
	S ROUGLOB=$$ROULOC^XTDEBUG("ZZUTXTD1")
	D CHKEQ^XTMUNIT(ROUGLOB,1,"Bad location for routine global")
	Q
	;
LINENUM	;
	N XXLIN
	S XXLIN=$$LINENUM^XTDEBUG("ZZUTXTD1","OPENTAG+2")
	D CHKEQ^XTMUNIT(XXLIN,20,"Wrong line number for OPENTAG+2")
	Q
	;
TAGNUM	;
	N XXLIN
	S XXLIN=$$LINENUM^XTDEBUG("ZZUTXTD1","OPENTAG+2")
	S XXLIN=$$TAGNUM^XTDEBUG("ZZUTXTD1",XXLIN)
	D CHKEQ^XTMUNIT(XXLIN,"OPENTAG+2","Bad return from TAGLINE")
	Q
	;
GETLINE	;
	N XXLIN
	S XXLIN=$$GETLINE^XTDEBUG("ZZUTXTD1","GETLINE+2")
	D CHKEQ^XTMUNIT(XXLIN,$T(GETLINE+2^ZZUTXTD1),"Bad code line returned")
	Q
	;
DOSTART	;
	N X1,Y1,VAR1,VAR2,XVALS
	S X1=4,Y1=3,VAR1="A",VAR2=4="B"
	D CHKEQ^XTMUNIT(VAR1,"A","WEIRD VALUE")
	D START^XTDEBUG(.XVALS,"D TESTENT^ZZUTXTD1(X1,Y1)")
	D NEXT^XTDEBUG(.XVALS,"STEP")
	D CHKEQ^XTMUNIT(VAR1,"4","Incorrect value for VAR1 a")
	D CHKEQ^XTMUNIT(VAR2,"3","Incorrect value for VAR2")
	D NEXT^XTDEBUG(.XVALS,"STEP")
	D CHKEQ^XTMUNIT(VAR1,"4","Incorrect value for VAR1 B")
	D CHKEQ^XTMUNIT(VAR2,"3","Incorrect value for VAR2")
	D NEXT^XTDEBUG(.XVALS,"STEP")
	D CHKEQ^XTMUNIT(VAR1,"4","Incorrect value for VAR1 C")
	D CHKEQ^XTMUNIT(VAR2,"3","Incorrect value for VAR2")
	Q
	;
SETBREAK	;
	N LINNUM,GLOBLOC,VALUE,RESULTS,GLOBBRK
	S GLOBBRK=$$GETBREAK^XTDEBUG()
	K @GLOBBRK
	S VALUE="TESTENT+2^ZZUTXTD1"
	D SETBREAK^XTDEBUG(.RESULTS,VALUE)
	S LINNUM=$$LINENUM^XTDEBUG("ZZUTXTD1","TESTENT+2")
	S GLOBLOC=$$GETGLOBS^XTDEBUG()
	D CHKEQ^XTMUNIT($D(@GLOBBRK@("+"_LINNUM_"^ZZUTXTD1")),1,"BREAK data not set correctly")
	K @GLOBBRK
	Q
	;
BREAKFRM	;
	N LINNUM,VALUE
	S LINNUM=$$LINENUM^XTDEBUG("ZZUTXTD1","TESTENT+2")
	S VALUE=$$BREAKFRM^XTDEBUG("TESTENT+2^ZZUTXTD1")
	D CHKEQ^XTMUNIT(VALUE,"+"_LINNUM_"^ZZUTXTD1","Incorrect form for break value")
	Q
	;
CHECKBRK	;
	N GLOBLOC,BREAK,LINNUM,XVALUE,RESULTS,GLOBBRK
	S GLOBLOC=$$GETGLOB^XTDEBUG(),GLOBLOC=$NA(@GLOBLOC@("BREAK")) K @GLOBLOC
	S BREAK="TESTENT+2^ZZUTXTD1"
	D SETBREAK^XTDEBUG(.RESULTS,BREAK)
	S LINNUM=$$LINENUM^XTDEBUG("ZZUTXTD1","TESTENT+2")
	S XVALUE=$$CHKBREAK^XTDEBUG("ZZUTXTD1",LINNUM)
	D CHKEQ^XTMUNIT(XVALUE,1,"Did not return correct breakpoint")
	S GLOBBRK=$$GETBREAK^XTDEBUG()
	K @GLOBBRK
	Q
	;
JLI	;
	N GLOBLOC,GLOBPRE,GLOBCURR
	S GLOBLOC=$$GETGLOB^XTDEBUG() K @GLOBLOC
	S GLOBPRE=$NA(@GLOBLOC@("PRE")),GLOBCURR=$NA(@GLOBLOC@("VALUES"))
	S @GLOBCURR@("XTENTRY",1)="PREPROS"
	S @GLOBCURR@("XTENTRY",1,"NAME")="PRE-PROCESSING OF $$ AND $S"
	S @GLOBCURR@("XTENTRY",2)="DOLRSX"
	S @GLOBCURR@("XTENTRY",2,"NAME")=""
	;S @GLOBCURR@("XTENTRY",3)="DOLRS"
	;S @GLOBCURR@("XTENTRY",3,"NAME")="handle $SELECT"
	;S @GLOBCURR@("XTENTRY",4)="CHKARGS"
	;S @GLOBCURR@("XTENTRY",4,"NAME")="check for arguments needing pre-processing"
	S @GLOBPRE@("XTENTRY",1)="PREPROS"
	S @GLOBPRE@("XTENTRY",1,"NAME")="PRE-PROCESSING OF $$ AND $S"
	;S @GLOBPRE@("XTENTRY",2)="DOLRSX"
	;S @GLOBPRE@("XTENTRY",2,"NAME")=""
	;S @GLOBPRE@("XTENTRY",3)="DOLRS"
	;S @GLOBPRE@("XTENTRY",3,"NAME")="handle $SELECT"
	;S @GLOBPRE@("XTENTRY",4)="CHKARGS"
	;S @GLOBPRE@("XTENTRY",4,"NAME")="check for arguments needing pre-processing"
	;S @GLOBPRE@("XTENTRY",5)="PASBYREF"
	;S @GLOBPRE@("XTENTRY",5,"NAME")="handle arguments passed by reference"
	;S @GLOBPRE@("XTENTRY",6)="SETDOLR"
	;S @GLOBPRE@("XTENTRY",6,"NAME")="various tests of functions"
	;S @GLOBPRE@("XTENTRY",7)="DONOARG1"
	;S @GLOBPRE@("XTENTRY",7,"NAME")="multiple argless DO commands"
	;S @GLOBPRE@("XTENTRY",8)="GETPERIO"
	;S @GLOBPRE@("XTENTRY",8,"NAME")="returns number of periods at start of line"
	Q
CHKCHANG	;
	N GLOBLOC,GLOBPRE,GLOBCURR,RESULTS
	S GLOBLOC=$$GETGLOB^XTDEBUG() K @GLOBLOC
	S GLOBPRE=$NA(@GLOBLOC@("PRE")),GLOBCURR=$NA(@GLOBLOC@("VALUES"))
	S @GLOBPRE@("PREONLY")="PREONLY VALUE"
	S @GLOBCURR@("CURRONLY")="CURRONLY VALUE"
	S @GLOBPRE@("BOTHSAME")="BOTHSAME VALUE",@GLOBCURR@("BOTHSAME")="BOTHSAME VALUE"
	S @GLOBPRE@("BOTHSAME","A")="BOTHSAME A"
	S @GLOBPRE@("BOTHDIFF")="BOTHDIFF P VALUE",@GLOBCURR@("BOTHDIFF")="BOTHDIFF C VALUE"
	S @GLOBPRE@("SUBSAME",1,2)="SUBSAME VALUE",@GLOBCURR@("SUBSAME",1,2)="SUBSAME VALUE"
	S @GLOBPRE@("PRESUB",2)="PRESUB VALUE",@GLOBCURR@("CURSUB",3)="CURSUB VALUE"
	S @GLOBPRE@("SUBDIFF1",1,2)="SUBDIFF1 P VALUE",@GLOBCURR@("SUBDIFF1",1,2)="SUBDIFF1 C VALUE"
	S @GLOBPRE@("SUBDIFF2",1)="SUBDIFF2 VALUE",@GLOBCURR@("SUBDIFF2",2)="SUBDIFF2 VALUE"
	S @GLOBCURR@("XTENTRY",1)="PREPROS"
	S @GLOBCURR@("XTENTRY",1,"NAME")="PRE-PROCESSING OF $$ AND $S"
	S @GLOBCURR@("XTENTRY",2)="DOLRSX"
	S @GLOBCURR@("XTENTRY",2,"NAME")=""
	S @GLOBCURR@("XTENTRY",3)="DOLRS"
	S @GLOBCURR@("XTENTRY",3,"NAME")="handle $SELECT"
	;S @GLOBCURR@("XTENTRY",4)="CHKARGS"
	;S @GLOBCURR@("XTENTRY",4,"NAME")="check for arguments needing pre-processing"
	S @GLOBPRE@("XTENTRY",1)="PREPROS"
	S @GLOBPRE@("XTENTRY",1,"NAME")="PRE-PROCESSING OF $$ AND $S"
	;S @GLOBPRE@("XTENTRY",2)="DOLRSX"
	;S @GLOBPRE@("XTENTRY",2,"NAME")=""
	;S @GLOBPRE@("XTENTRY",3)="DOLRS"
	;S @GLOBPRE@("XTENTRY",3,"NAME")="handle $SELECT"
	;S @GLOBPRE@("XTENTRY",4)="CHKARGS"
	;S @GLOBPRE@("XTENTRY",4,"NAME")="check for arguments needing pre-processing"
	;S @GLOBPRE@("XTENTRY",5)="PASBYREF"
	;S @GLOBPRE@("XTENTRY",5,"NAME")="handle arguments passed by reference"
	;S @GLOBPRE@("XTENTRY",6)="SETDOLR"
	;S @GLOBPRE@("XTENTRY",6,"NAME")="various tests of functions"
	;S @GLOBPRE@("XTENTRY",7)="DONOARG1"
	;S @GLOBPRE@("XTENTRY",7,"NAME")="multiple argless DO commands"
	;S @GLOBPRE@("XTENTRY",8)="GETPERIO"
	;S @GLOBPRE@("XTENTRY",8,"NAME")="returns number of periods at start of line"
	D CHKCHANG^XTDEBUG(.RESULTS,GLOBPRE,GLOBCURR)
	D CHKEQ^XTMUNIT($D(@RESULTS@("PREONLY",0)),1,"PREONLY NOT IDENTIFIED")
	D CHKEQ^XTMUNIT($D(@RESULTS@("PREONLY",1)),0,"PREONLY FOUND IN CURR")
	D CHKEQ^XTMUNIT($D(@RESULTS@("BOTHSAME")),0,"BOTHSAME WAS IDENTIFIED INCORRECTLY")
	D CHKEQ^XTMUNIT($D(@RESULTS@("BOTHDIFF",0)),1,"BOTHDIFF MISSING IN PRE")
	D CHKEQ^XTMUNIT($D(@RESULTS@("BOTHDIFF",1)),1,"BOTHDIFF MISSING IN CURR")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBSAME")),0,"SUBSAME WAS IDENTIFIED INCORRECTLY")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBDIFF1(1,2)",0)),1,"SUBDIFF1 P WAS NOT FOUND")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBDIFF1(1,2)",1)),1,"SUBDIFF1 C WAS NOT FOUND")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBDIFF2(1)",0)),1,"SUBDIFF2 1 P WAS NOT FOUND")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBDIFF2(2)",1)),1,"SUBDIFF2 C WAS FOUND INCORRECTLY")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBDIFF1(1,2)",0)),1,"SUBDIFF2 2 P WAS FOUND INCORRECTLY")
	D CHKEQ^XTMUNIT($D(@RESULTS@("SUBDIFF1(1,2)",1)),1,"SUBDIFF1 2 C WAS NOT FOUND")
	D CHKEQ^XTMUNIT($D(@RESULTS@("PRESUB(2)",0)),1,"PRESUB WAS NOT FOUND")
	D CHKEQ^XTMUNIT($D(@RESULTS@("CURSUB(3)",1)),1,"CURSUB WAS NOT FOUND")
	Q
	;
CHKWATCH	;
	N GLOBLOC,I,RESULTS,VALUE,XX,GLOBWAT
	S GLOBLOC=$$GETGLOB^XTDEBUG() K @GLOBLOC
	S @GLOBLOC@("PRE","X1")="A",@GLOBLOC@("VALUES","X1")="B"
	S @GLOBLOC@("PRE","Y1")="A",@GLOBLOC@("VALUES","Y1")="B"
	S @GLOBLOC@("PRE","Y2")="A"
	S @GLOBLOC@("PRE","Z(1)")="A",@GLOBLOC@("PRE","Z(2)")="B"
	S @GLOBLOC@("PRE","W")="A"
	D CHKCHANG^XTDEBUG(.RESULTS,$NA(@GLOBLOC@("PRE")),$NA(@GLOBLOC@("VALUES")))
	S GLOBWAT=$$GETGLOBS^XTDEBUG(),GLOBWAT=$NA(@GLOBWAT@("WATCH")) K @GLOBWAT
	S @GLOBWAT@("X1")="",@GLOBWAT@("Y*")="",@GLOBWAT@("Z")=""
	S VALUE=$$GETWATCH^XTDEBUG()
	S VALUE=$$CHKWATCH^XTDEBUG()
	D CHKEQ^XTMUNIT(VALUE,1,"WATCH change not found")
	S I="" F  S I=$O(@GLOBLOC@("RES","WATCH",I)) Q:I=""  S XX($P(^(I)," = "))=$P(^(I)," = ",2)
	D CHKEQ^XTMUNIT($G(XX("X1")),"A^B","Didn't find X1")
	D CHKEQ^XTMUNIT($D(XX("Y1"))+$D(XX("Y2")),2,"Didn't match Y*")
	D CHKEQ^XTMUNIT($D(XX("Z(1)"))+$D(XX("Z(2)")),2,"Didn't get subscripts")
	D CHKEQ^XTMUNIT($D(XX("W")),0,"Found W not on watch list")
	K @GLOBWAT
	Q
	;
XTROU	;
	;;ZZUTXTD1;
XTENT	;
	;;CHKCHANG;check for changes between previous and current
	;;DOSTART;start a debug process
	;;ROULOAD;load the routine
	;;LINENUM;get the line number
	;;TAGNUM;get line number as offset from nearest TAG
	;;ROUGLOB;generate routine global location
	;;ROULOC;determines index location for a routine, makes it if necessary
	;;GETLINE;gets code part of specified line
	;;BREAKFRM;sets up format for break data
	;;SETBREAK;sets up break
	;;CHECKBRK;check for breakpoint
	;;CHKWATCH;check on WATCH for variable change functionality

XTDEBSKP	;JLI/FO-OAK-TEST ROUTINE FOR SKIP ;5/9/07  13:56
	;;7.3;TOOLKIT;**???**;Apr 25, 1995
	Q
GETCMNDS(LINE,XTDEBVAL)	;  main entry
	;
	; usage   D ENTRY(LINE,.XTDEBVAL)
	;
	;  LINE is a line of code to be analyzed
	;
	;  XTDEBVAL passed by reference and on return contains an array of the commands in LINE and a subarray
	;           of the arguments to which each command applies.  It may also contain information on pre
	;           and post conditional statements for the commands or arguments
	;
	N XTDEBCOD,XTDEBCNT,XTDEBARG
	S XTDEBCOD=LINE,XTDEBCNT=0
	K XTDEBVAL
	F  Q:XTDEBCOD=""  S XTDEBCNT=XTDEBCNT+1,XTDEBCOD=$$GETCMND(.XTDEBARG,XTDEBCOD) M XTDEBVAL(XTDEBCNT)=XTDEBARG
	Q
	;
GETCMND(XTDEBRES,XTDEBCMD)	;
	N XTDEBLIN,XTDEBVAL,XTDEBTYP,XTDEBARG,XTDEBCNT,XTDEBPOS
	K XTDEBRES
	S XTDEBCNT=0
	S XTDEBCMD=$$GETSTR(.XTDEBTYP,XTDEBCMD," :")
	; get one letter version of commands
	S XTDEBRES("CMND")=$E(XTDEBTYP)
	I XTDEBTYP("TERM")=":" S XTDEBCMD=$$GETSTR(.XTDEBTYP,XTDEBCMD," ") S XTDEBRES("PRECOND")=XTDEBTYP
	I XTDEBTYP("TERM")'=" " Q ""
	S XTDEBPOS=" ,:"
	F  S XTDEBCMD=$$GETSTR(.XTDEBARG,XTDEBCMD,XTDEBPOS) D  Q:XTDEBARG("TERM")=" "  Q:XTDEBARG("TERM")=""
	. S XTDEBCNT=XTDEBCNT+1,XTDEBRES("ARGS",XTDEBCNT)=XTDEBARG
	. I XTDEBARG("TERM")=":" S XTDEBCMD=$$GETSTR(.XTDEBARG,XTDEBCMD," ,"),XTDEBRES("ARGS",XTDEBCNT,"POSTCOND")=XTDEBARG Q:XTDEBARG("TERM")=" "
	. Q
	S XTDEBLIN=XTDEBCMD
	Q $G(XTDEBLIN)
	;
GETSTR(XTDEBSTR,XTDEBINP,XTDEBTRM)	;
	N XTDEBOUT,XTDEBDON,XTDEBPRN,XTDEBQUO,XTDEBCHR
	K XTDEBSTR
	S XTDEBOUT=XTDEBINP
	S XTDEBSTR="",XTDEBDON=0,XTDEBQUO=0,XTDEBPRN=0
	F  S XTDEBCHR=$E(XTDEBOUT),XTDEBOUT=$E(XTDEBOUT,2,500) Q:XTDEBCHR=""  D  Q:XTDEBDON
	. I XTDEBTRM[XTDEBCHR,XTDEBPRN=0,XTDEBQUO=0 S XTDEBDON=1 Q
	. S:XTDEBCHR="""" XTDEBQUO=$S(XTDEBQUO>0:XTDEBQUO-1,1:XTDEBQUO+1)
	. S:XTDEBCHR="(" XTDEBPRN=XTDEBPRN+1 S:XTDEBCHR=")" XTDEBPRN=XTDEBPRN-1
	. S XTDEBSTR=XTDEBSTR_XTDEBCHR
	. Q
	S XTDEBSTR("TERM")=XTDEBCHR
	Q XTDEBOUT

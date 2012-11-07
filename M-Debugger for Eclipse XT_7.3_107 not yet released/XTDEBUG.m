XTDEBUG ;JLI-M DEBUGGER ;06/13/08  16:29
 ;;7.3;TOOLKIT;**107**;Apr 25, 1995;Build 14
 ;;Per VHA Directive 2004-038, this routine should not be modified
 D EN^XTMUNIT("ZZUTXTD1") W !,DUZ
 Q
 ;
 ; 040909 PM -- over the past few days I have realized that the functions for entry and
 ;              return from a tag (e.g., DO, $$, and perhaps GO) have to be independent
 ;              of the current routine name and current line references.  In some cases
 ;              there will be no current routine name and line reference appropriate, e.g.,
 ;              in the case of execute statements, or in the case of code involved with
 ;              do's with no argument.
 ;
 ;              Instead the code should use the "CMND" reference for the current level
 ;              to continue processing, and ENTRY references to determine the type of
 ;              processing to return to.
 ;
 ; 050723 --    In STEP mode the current version is not stopping at the beginning of each
 ;              line, on return from a DO, etc.
 ;
START(XTDEBRES,XTDEBCMD) ; .RPC entry point
 S XTDEBCM1=XTDEBCMD
 ; this tag is called only on initial call, all subsequent calls
 ; should be for the tag NEXT to continue the debugging process
 ;
 ; XTDEBRES - a closed global reference is returned as the result
 ;            which can be used to access all of the data being returned
 ; XTDEBCMD - a string which contains the information about the TAG
 ;            to be used as the entry for debugging.  This is in the
 ;            form that it would appear following a DO or =$$ reference
 ;            as appropriate for the tag.
 ;            e.g.,   "EN^TESTROU(.XVAR,YVAL,""INPUT STRING"")"
 ;
 N XTDEBPAR,XTDEBLNM,XTDEBCOD,XTDEBARG,XTDEBLOC,XTDEBCUR,XTDEBROU
 N XTDEBTAG
 ; ZEXCEPT: XTDEBLGR   - this is a global variable
 S XTDEBLGR=$$LGR^%ZOSV ; capture last global reference
 S XTDEBLOC=$$GETGLOB() K @XTDEBLOC ; clear all entries, etc.
 S XTDEBRES=$$RESULTS() K @XTDEBRES
 M @XTDEBLOC@("XTDEBDUZ")=DUZ
 D STRTVALS ; save off copy of initial values
 D DEBUG^XTMLOG("START TO VALUES")
 ; following line now handled by STRTVALS
 ;D VALUES ; get initial values before entry for comparisons
 ; 040911 -- modify to use GETCMND for args, etc.
 ; I "^D^G^X^DO^GO^XECUTE^"'[("^"_$P(XTDEBCMD," ")_"^") S XTDEBCMD="D "_XTDEBCMD
 S @XTDEBLOC@("EXITTYPE")="START"
 ; to command line add W ! to flush output Q to insure we quit properly
 I $E(XTDEBCMD,$L(XTDEBCMD))'="Q" S XTDEBCMD=XTDEBCMD_" Q"
 ;    set lastlvl = 0
 S @XTDEBLOC@("LASTLVL")=0,@XTDEBLOC@("LVL",0,"CODE")=XTDEBCMD,^("ROUTINE")="@",^("LINE")="",^("TYPE")="XECUTE",^("CMND")=XTDEBCMD
 D DEBUG^XTMLOG("NEW XTDEBCMD","XTDEBCMD")
 I XTDEBCMD[U D
 . D DEBUG^XTMLOG("IN NEW CODE")
 . S XTDEBROU=$P(XTDEBCMD,U,2),XTDEBROU=$P(XTDEBROU," "),XTDEBROU=$P(XTDEBROU,"(")
 . D DEBUG^XTMLOG("XTDEBROU","XTDEBROU")
 . Q:XTDEBROU=""  S XTDEBTAG=$P(XTDEBCMD,U)
 . I XTDEBTAG["$$" S XTDEBTAG=$P(XTDEBTAG,"$$",2)
 . S XTDEBTAG=$P(XTDEBTAG," ",$L(XTDEBTAG," ")) S XTDEBTAG=$$LINENUM(XTDEBROU,XTDEBTAG)
 . D DEBUG^XTMLOG("XTDEBROU","XTDEBROU,XTDEBTAG")
 . S @XTDEBLOC@("LVL",0,"ROUTINE")=XTDEBROU,^("LINE")=XTDEBTAG
 . Q
 D DEBUG^XTMLOG("START","XTDEBCMD")
 S @XTDEBLOC@("LVL",0,"ENTRY")="DOLINE"
 D REASON("START",1) ;S @XTDEBRES@(" REASON")="SECTION=REASON",@XTDEBRES@(" REASON",0)="START:  " ;  _(XTDEBLNM+1)_"   : "_$$GETLINE(XTDEBROU,"+"_(XTDEBLNM+1))
 Q
 ;
NEXT(XTDEBRES,XTDEBTYP) ; .RPC- rpc to be used for each subsequent entry after initial entry
NEXT1 ;
 N XTDEBLOC,XTDEBROU,XTDEBRTN,XTDEBCOD,XTDEBLNM,XTDEBENT,XTDEBLVL
 N XTDEBCUR,XTDEBTR1,XTDEBXXX,XTDEBCMD,XTDEBEN1
 S XTDEBENT=1,XTDEBEN1=1
 D DEBUG^XTMLOG("RE-ENTRY AT NEXT")
 S XTDEBLOC=$$GETGLOB(),XTDEBLVL=@XTDEBLOC@("LASTLVL")
 N DUZ M DUZ=@XTDEBLOC@("XTDEBDUZ") ; protect original value of DUZ
 I $D(@XTDEBLOC@("SV")) F XTDEBRTN=1:1:26 S XTDEBCOD=$C(64+XTDEBRTN) K @XTDEBCOD M:$D(@XTDEBLOC@("SV",XTDEBCOD)) @(XTDEBCOD)=@XTDEBLOC@("SV",XTDEBCOD)
 K XTDEBRTN
 I '$D(U) S U="^"
 S @XTDEBLOC@("EXITTYPE")=XTDEBTYP
 ;
NEXTENT ;
 S XTDEBLOC=$$GETGLOB(),XTDEBRES=$$RESULTS()
 S XTDEBLVL=+$G(@XTDEBLOC@("LASTLVL"))
 D INFO^XTMLOG("ENTERED NEXTENT","XTDEBLVL")
 K @XTDEBLOC@("LVL",XTDEBLVL,"VALUESDONE") ;I '$D(XTDEBENT) D VALUES I $$CHKQUIT() Q
 D DEBUG^XTMLOG("NEXTENT1","XTDEBLVL,"_$NA(@XTDEBLOC@("LVL",XTDEBLVL,"ENTRY"))_","_$NA(@XTDEBLOC@("LVL",XTDEBLVL,"CMND")))
 ; following is true only if finished processing (level 0 is original input line)
 I XTDEBLVL=0,($G(@XTDEBLOC@("LVL",XTDEBLVL,"CMND"))="")!($G(^("CMND"))="Q"),$G(^("ENTRY"))="" D REASON^XTDEBUG("DONE",0) Q  ;S @XTDEBRES@(" REASON")="SECTION=REASON",^(" REASON",0)="PROCESSING IS DONE!" Q
 I XTDEBLVL<0 D REASON^XTDEBUG("DONE",0) Q
 D DEBUG^XTMLOG("NEXTENT1A","XTDEBLVL,"_$NA(@XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")))
 I $G(@XTDEBLOC@("LVL",XTDEBLVL,"ROUTINE"))="@",$G(^("CMND"))="",'$D(^("XTDEBARG","ARGS")) S @XTDEBRES@(" REASON")="SECTION=REASON",^(" REASON",0)="PROCESSING IS DONE!" Q
 I $G(@XTDEBLOC@("LVL",XTDEBLVL))=0,$G(^("CMND"))="",'$D(^("XTDEBARG","ARGS")) S @XTDEBRES@(" REASON")="SECTION=REASON",^(" REASON",0)="PROCESSING IS DONE!" Q
 D DEBUG^XTMLOG("NEXTENT1B","XTDEBLVL,"_$NA(@XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")))
 ;I XTDEBLVL>0 S XTDEBXXX=$G(@XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")) I XTDEBXXX'="" G @XTDEBXXX
 S XTDEBXXX=$G(@XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")) I XTDEBXXX'="" G @XTDEBXXX
 ; move to next line of current routine
 K @XTDEBLOC@("LVL",XTDEBLVL,"CMND PERIODS")
 S XTDEBROU=$G(@XTDEBLOC@("LVL",XTDEBLVL,"ROUTINE")),XTDEBLNM=$G(@XTDEBLOC@("LVL",XTDEBLVL,"LINE"))+1
 D DEBUG^XTMLOG("NEXTENT1C","XTDEBROU,XTDEBLNM")
 ;    look for breakpoint, if current line is one and we haven't just re-entered, set up results and leave
 ;    test needed only for coming in without going through START
 D DEBUG^XTMLOG("NEXTENT1D","XTDEBLVL,"_$NA(@XTDEBLOC@("LVL",XTDEBLVL,"ENTRY")))
 K XTDEBENT,XTDEBEN1
 D DEBUG^XTMLOG("NEXTENT")
 S XTDEBCOD=$$GETLINE(XTDEBROU,"+"_XTDEBLNM)
 D DEBUG^XTMLOG("NEXTENT","XTDEBCOD")
 S XTDEBCMD=$P(XTDEBCOD," ",2,99)
 D DEBUG^XTMLOG("NEXTENT 2","XTDEBCOD,XTDEBROU,XTDEBLNM")
 I XTDEBLNM'>0,XTDEBCOD="" D REASON("DONE") Q
 S XTDEBLVL=@XTDEBLOC@("LASTLVL"),@XTDEBLOC@("LVL",XTDEBLVL,"CODE")=XTDEBCOD,^("ROUTINE")=XTDEBROU,^("LINE")=XTDEBLNM,^("CMND")=XTDEBCMD
 I $E(XTDEBCMD,1,2)=";;" Q
 G DOLINE ;
 ;
CHKQUIT(XTDEBNUM) ;
 N XTDEBLOC,XTDEBLVL,XTDEBLIN,XTDEBUGI
 S:$G(XTDEBNUM)="" XTDEBNUM=1
 S XTDEBLOC=$$GETGLOB(),XTDEBLVL=@XTDEBLOC@("LASTLVL")
 D DEBUG^XTMLOG("CHKQUIT0")
 D VALUES
 D DEBUG^XTMLOG("CHKQUIT1")
 S @XTDEBLOC@("LASTCMND")=$G(@XTDEBLOC@("CURRCMND"))
 S XTDEBLIN="" F XTDEBUGI=1:1 Q:'$D(@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",XTDEBUGI))  D
 . N XTDEBVAL S XTDEBVAL=$S($D(@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",XTDEBUGI,"ORIGINAL")):^("ORIGINAL"),1:@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","ARGS",XTDEBUGI))
 . S XTDEBLIN=XTDEBLIN_$S(XTDEBUGI>1:",",1:"")_XTDEBVAL_$S($G(^(XTDEBUGI,"POSTCOND"))'="":":"_^("POSTCOND"),1:"")
 . Q
 I $G(@XTDEBLOC@("LVL",XTDEBLVL,"XTDEBARG","CMND"))'="" S XTDEBLIN=^("CMND")_$S($D(^("CMND","PRECOND")):":"_^("PRECOND"),1:"")_" "_XTDEBLIN
 S @XTDEBLOC@("CURRCMND")=XTDEBLIN
 I $$CHKBREAK($G(@XTDEBLOC@("LVL",XTDEBLVL,"ROUTINE")),$G(@XTDEBLOC@("LVL",XTDEBLVL,"LINE"))) D REASON("BREAK",XTDEBNUM) Q 1
 I $G(@XTDEBLOC@("EXITTYPE"))="STEP",'$D(@XTDEBLOC@("LVL",XTDEBLVL,"PRE-PROCESS")) D REASON("STEP",XTDEBNUM) Q 1
 I $G(@XTDEBLOC@("EXITTYPE"))="START" D REASON("START",XTDEBNUM) Q 1
 I $$CHKWATCH() D REASON("WATCH",XTDEBNUM) Q 1
 Q 0
 ;
READDATA(XTDEBRES,XTDEBVAL,XTDEBTO,XTDEBTYP) ; entry point for return from a READ command
 N XTDEBLOC,XTDEBLVL,XTDEBVAR
 ; ZEXCEPT: XTDEBTST  -- global - used as data holder for $TEST variable
 D DEBUG^XTMLOG("RE-ENTERED AT READDATA")
 S XTDEBRES=$$RESULTS()
 S XTDEBLOC=$$GETGLOB()
 S XTDEBLVL=@XTDEBLOC@("LASTLVL")
 S XTDEBVAR=@XTDEBLOC@("LVL",XTDEBLVL,"READVAR")
 I XTDEBTO S XTDEBTST=0
 X "S @XTDEBVAR=XTDEBVAL"
 D DEBUG^XTMLOG("XTDEBVAL","XTDEBVAL,XTDEBVAR")
 D NEXT(.XTDEBRES,XTDEBTYP)
 Q
 ;
GETGLOB() ; simply returns the base global location for storage
 Q $NA(^TMP("XTDEBUG",$J))
 ;
RESULTS() ; intrinsic function to return closed global reference to results
 Q $NA(@$$GETGLOB()@("RES"))
 ;
ROUGLOB() ;
 Q $NA(@$$GETGLOB()@("ROU"))
 ;
CHANGGLO() ;
 Q $NA(^TMP($J,"RESULTS"))
 ;
 ;
 ;  XTDEBUG1 ---
 ;
STRTCMND ;
 G STRTCMND^XTDEBUG1
 ;
COMMANDS ;
 G COMMANDS^XTDEBUG1
 ;
EXITCMND ;
 G EXITCMND^XTDEBUG1
 ;
DOLINE ;
 G DOLINE^XTDEBUG1
 ;
DOLINE1 ;
 G DOLINE1^XTDEBUG1
 ;
 ;  XTDEBUG2 ----
 ;
STRTFOR ;
 G STRTFOR^XTDEBUG2
 ;
FORCMND ;
 G FORCMND^XTDEBUG2
 ;
NEXTFOR ;
 G NEXTFOR^XTDEBUG2
 ;
ENDFOR ;
 G ENDFOR^XTDEBUG2
 ;
SETDOLT ;
 D SETDOLT^XTDEBUG2
 Q
 ;
SETLGR ;
 D SETLGR^XTDEBUG2
 Q
 ;
RESETLGR ;
 D RESETLGR^XTDEBUG2
 Q
 ;
CHKARGS(XTDEBINP,XTDEBCNT) ;
 Q $$CHKARGS^XTDEBUG2(.XTDEBINP,.XTDEBCNT)
 ;
PREPROCS ;
 G PREPROCS^XTDEBUG2
 ;
DOLRTEXT(ARG,ROUTINE) ;
 Q $$DOLRTEXT^XTDEBUG2(ARG,ROUTINE)
 ;
QUERYNUM(VALUE) ;
 Q $$QUERYNUM^XTDEBUG2(VALUE)
 ;
 ;  XTDEBUG3 ---
 ;
GETVALS(RESULTS) ;
 D GETVALS^XTDEBUG3(.RESULTS)
 Q
 ;
VALUES ;
 D VALUES^XTDEBUG3
 Q
 ;
CHKCHANG(XTDEBRES,XTDEB1,XTDEB2) ;
 D CHKCHANG^XTDEBUG3(.XTDEBRES,$G(XTDEB1),$G(XTDEB2))
 Q
 ;
 ;  XTDEBUG4 ---
 ;
OPENTAG(XTDEBAL1,XTDEBAL2) ;
 D OPENTAG^XTDEBUG4($G(XTDEBAL1),$G(XTDEBAL2))
 Q
 ;
LEAVETAG ;
 G LEAVETAG^XTDEBUG4
 ;
NEWVARS(XTDEBVAR) ;
 D NEWVARS^XTDEBUG4(.XTDEBVAR)
 Q
 ;
ADDLEVEL ;
 G ADDLEVEL^XTDEBUG4
 ;
POPLEVEL ;
 G POPLEVEL^XTDEBUG4
 ;
 ;  XTDEBUG5 ---
 ;
RETVALS(XTDEBRES,XTDEBLOC) ;
 D RETVALS^XTDEBUG5(.XTDEBRES,XTDEBLOC)
 Q
 ;
SETWATCH(XTDEBRES,XTDEBWAT) ;
 D SETWATCH^XTDEBUG5(.XTDEBRES,$G(XTDEBWAT))
 Q
 ;
CLRWATCH(XTDEBRES,XTDEBWAT) ;
 D CLRWATCH^XTDEBUG5(.XTDEBRES,$G(XTDEBWAT))
 Q
 ;
GETWATCH() ;
 Q $$GETWATCH^XTDEBUG5()
 ;
CHKWATCH() ;
 Q $$CHKWATCH^XTDEBUG5()
 ;
BREAKFRM(XTDEBINP) ; takes data in form TAG+N^ROUTINE and returns it as +LIN^ROUTINE, where LIN is from start of routine
 Q $$BREAKFRM^XTDEBUG5($G(XTDEBINP))
 ;
SETBREAK(XTDEBRES,XTDEBBRK) ; Usage D SETBREAK(.RESULTS,BRKARRAY)
 D SETBREAK^XTDEBUG5(.XTDEBRES,$G(XTDEBBRK))
 Q
 ;
CLRBREAK(XTDEBRES,XTDEBBRK) ; Usage D CLRBREAK(.RESULTS,BRKARRAY)
 D CLRBREAK^XTDEBUG5(.XTDEBRES,$G(XTDEBBRK))
 Q
 ;
CHKBREAK(XTDEBROU,XTDEBLIN) ; Usage VALUE=$$CHKBREAK(ROUNAME,LINEID) returns 1 if a breakpoint is set on the line
 Q $$CHKBREAK^XTDEBUG5($G(XTDEBROU),$G(XTDEBLIN))
 ;
 ;  XTDEBUG6 ---
 ;
GETBREAK() ;
 N XTDEBLOC S XTDEBLOC=$$GETGLOBS()
 Q $NA(@XTDEBLOC@("BREAK"))
 ;
GETGLOBS() ;
 Q $$GETGLOBS^XTDEBUG5()
 ;
GETCMND(XTDEBRES,XTDEBCMD) ;
 Q $$GETCMND^XTDEBUG6(.XTDEBRES,$G(XTDEBCMD))
 ;
GETSTR(XTDEBSTR,XTDEBINP,XTDEBTRM) ;
 Q $$GETSTR^XTDEBUG6(.XTDEBSTR,$G(XTDEBINP),$G(XTDEBTRM))
 ;
 ;  XTDEBUG7 ---
 ;
REASON(XTDEBTYP,XTDEBNUM) ;
 D REASON^XTDEBUG7($G(XTDEBTYP),$G(XTDEBNUM))
 Q
 ;
OPENDO ;(XTDEBCMD,XTDEBVAR) ;
 G OPENDO^XTDEBUG7
 ;
TAGPARTS(XTDEBRES,XTDEBINP) ;
 D TAGPARTS^XTDEBUG7(.XTDEBRES,$G(XTDEBINP))
 Q
 ;
SETROU(XTDEBROU) ;
 Q $$SETROU^XTDEBUG7($G(XTDEBROU))
 ;
GETLINE(XTDEBROU,XTDEBLIN) ;
 Q $$GETLINE^XTDEBUG7($G(XTDEBROU),$G(XTDEBLIN))
 ;
ROULOC(XTDEBROU) ;
 Q $$ROULOC^XTDEBUG7($G(XTDEBROU))
 ;
LINENUM(XTDEBROU,XTDEBLIN) ; get line number relative to top of routine
 Q $$LINENUM^XTDEBUG7($G(XTDEBROU),$G(XTDEBLIN))
 ;
TAGNUM(XTDEBROU,XTDEBLIN) ; get line number relative to closest TAG, e.g., TAG+3
 Q $$TAGNUM^XTDEBUG7($G(XTDEBROU),$G(XTDEBLIN))
 ;
SETVARS(XTDEBRES,XTDEBVAR) ;
 D SETVARS^XTDEBUG7(.XTDEBRES,.XTDEBVAR)
 Q
 ;
STKFROM(XTDEBLOC,XTDEBLVL) ;
 Q $$STKFROM^XTDEBUG7(XTDEBLOC,XTDEBLVL)
 ;
 ;   XTDEBUG8 ----
 ;
DONOARG ;
 G DONOARG^XTDEBUG8
 ;
GETPERIO(XTDEBLIN) ;
 Q $$GETPERIO^XTDEBUG8(.XTDEBLIN)
 ;
STRTVALS ;
 G STRTVALS^XTDEBUG3
 ;
STARTLOC() ; returns location to save variables at start
 Q $NA(@$$GETGLOB()@("START"))

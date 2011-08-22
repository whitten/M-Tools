ZZUTREDO	;JLI/FO-OAK-UNIT TEST ROUTINE FOR XTMREDO ;08/07/11  22:47
	;;0.0;TOOLKIT;**TEST**;
	D EN^XTMUNIT("ZZUTREDO")
	Q
	;
LOG	;
	N XTMLOG
	D FILEINIT^XTMLOG("ZZUTXTMR")
	S XTMLOG=1
	D EN^XTMUNIT("ZZUTREDO")
	D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
SETUP	; capture JLITEST1 if present to be able to restore
	N DIF,X,XCNP
	K ^TMP("ZZUTXTMR1")
	S DIF="^TMP(""ZZUTXTMR1"",",XCNP=0,X="JLITEST1"
	I $T(JLITEST1^JLITEST1)'="" X ^%ZOSF("LOAD")
	Q
	;
TEARDOWN	; restore, if present, original JLITEST1
	D SAVE1("JLITEST1") ; SAVE ROUTINE IF EXISTED ON ENTRY, OTHERWISE REMOVE
	D SAVE1("ZZ"_$$DATESTR_"JLITEST1") ; REMOVE CREATED TEST ROUTINE
	Q
	;
SAVE1(ROUNAME)	;
	N DIE,DIF,X,XCN
	S (DIF,DIE)="^TMP(""ZZUTXTMR1"",",XCN=0,X=ROUNAME N ROUNAME S ROUNAME="JLITEST1"
	X ^%ZOSF("SAVE")
	K ^TMP("ZZUTXTMR1")
	Q
	;
SAVEROU(ROU,ARRAY).	; utility to save lines as routine for testing
	N I,DIF,DIE,XCN,X
	K ^TMP($J)
	F I=0:0 S I=$O(ARRAY(I)) Q:I<1  D
	. I ARRAY(I)="" Q
	. I ARRAY(I)[$C(9) S ARRAY(I)=$P(ARRAY(I),$C(9))_" "_$P(ARRAY(I),$C(9),2,99)
	. F  Q:$E(ARRAY(I),$L(ARRAY(I)))'=" "  S ARRAY(I)=$E(ARRAY(I),1,$L(ARRAY(I))-1)
	. S ^TMP($J,I,0)=ARRAY(I)
	. Q
	S (DIF,DIE)="^TMP($J,",XCN=0,X=ROU N ROUNAME S ROUNAME=ROU
	X ^%ZOSF("SAVE")
	K ARRAY
	Q
	;
LOADROU(ROUNAME,ARRAYNAM)	;
	N DIF,XCNP,X
	S DIF=ARRAYNAM_"(",XCNP=0,X=ROUNAME
	X ^%ZOSF("LOAD")
	Q
	;
NRMLDO	; test normal do statement
	N ROU,ARRAY,EXPECTED,ACTUAL
	S ROU="JLITEST1"
	S ARRAY(1)=" D E1,E2",EXPECTED(1)=" DO E1",EXPECTED(2)=" DO E2"
	S ARRAY(2)=" Q",EXPECTED(3)=" QUIT"
	S ARRAY(3)="E1 S X=1",EXPECTED(4)="E1 SET X=1"
	S ARRAY(4)=" Q",EXPECTED(5)=" QUIT"
	S ARRAY(5)="E2 S X=2",EXPECTED(6)="E2 SET X=2"
	S ARRAY(6)=" Q",EXPECTED(7)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D FAIL^XTMUNIT("TEST OF FAIL")
	Q
	;
POSTDO1	; test post conditional DO statements
	N ROU,ARRAY,EXPECTED,ACTUAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" D E1:X>4,E2",EXPECTED(1)=" DO E1:X>4",EXPECTED(2)=" DO E2"
	S ARRAY(2)=" Q",EXPECTED(3)=" QUIT"
	S ARRAY(3)="E1 S X=1",EXPECTED(4)="E1 SET X=1"
	S ARRAY(4)=" Q",EXPECTED(5)=" QUIT"
	S ARRAY(5)="E2 S X=2",EXPECTED(6)="E2 SET X=2"
	S ARRAY(6)=" Q",EXPECTED(7)=" QUIT"
	;D DEBUG^XTMLOG("ARRAY","ARRAY",1)
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	;D DEBUG^XTMLOG("EXPECTED","EXPECTED",1)
	;D DEBUG^XTMLOG("ACTUAL","ACTUAL",1)
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
POSTDO2	; test post conditional DO statements
	N ROU,ARRAY,EXPECTED,ACTUAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" D E1:X>4,E2:Y>3",EXPECTED(1)=" DO E1:X>4",EXPECTED(2)=" DO E2:Y>3"
	S ARRAY(2)=" Q",EXPECTED(3)=" QUIT"
	S ARRAY(3)="E1 S X=1",EXPECTED(4)="E1 SET X=1"
	S ARRAY(4)=" Q",EXPECTED(5)=" QUIT"
	S ARRAY(5)="E2 S X=2",EXPECTED(6)="E2 SET X=2"
	S ARRAY(6)=" Q",EXPECTED(7)=" QUIT"
	;D DEBUG^XTMLOG("ARRAY","ARRAY",1)
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	;D DEBUG^XTMLOG("EXPECTED","EXPECTED",1)
	;D DEBUG^XTMLOG("ACTUAL","ACTUAL",1)
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
IF1	; test IF statement with single command following
	N ROU,ARRAY,EXPECTED,ACTUAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" I X>4 S Y=1"
	S EXPECTED(1)=" IF X>4 SET Y=1"
	;S EXPECTED(1)=" IF X>4 IF $$DOIF1() QUIT" ;S EXPECTED(1)=" IF X>4 SET Y=1"
	S ARRAY(2)=" Q",EXPECTED(2)=" QUIT"
	;S EXPECTED(3)=" ;"
	;S EXPECTED(4)="DOIF1 ;"
	;S EXPECTED(5)=" SET Y=1"
	;S EXPECTED(6)=" QUIT 0"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
IFCOND1	;
	N ROU,ARRAY,EXPECTED,ACTUAL
	S ROU="JLITEST1"
	S ARRAY(1)=" S:X>4 Y=1"
	S EXPECTED(1)=" SET:X>4 Y=1"
	S ARRAY(2)=" Q",EXPECTED(2)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	Q
	;
IFCOND2	;
	N ROU,ARRAY,EXPECTED,ACTUAL
	S ROU="JLITEST1"
	S ARRAY(1)=" S:X>4 Y=1,Z=2 S A=3",EXPECTED(1)=" SET:X>4 Y=1",EXPECTED(2)=" SET:X>4 Z=2",EXPECTED(3)=" SET A=3"
	S ARRAY(2)=" Q",EXPECTED(4)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	Q
	;
IF2	;
	N ROU,ARRAY,EXPECTED,ACTUAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" I X>4 S Y=1,Z=3 D E1 S K=0"
	S EXPECTED(1)=" IF X>4 SET Y=1 SET Z=3 DO E1 SET K=0"
	S ARRAY(2)=" Q",EXPECTED(2)=" QUIT"
	S ARRAY(3)="E1 S X=2",EXPECTED(3)="E1 SET X=2"
	S ARRAY(4)=" Q",EXPECTED(4)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
IF3	;
	N ROU,ARRAY,EXPECTED,ACTUAL
	S ROU="JLITEST1"
	S ARRAY(1)=" I X>4,Y>5 S Y=1,Z=3 D E1 S K=0"
	S EXPECTED(1)=" IF X>4 IF Y>5 SET Y=1 SET Z=3 DO E1 SET K=0"
	S ARRAY(2)=" Q",EXPECTED(2)=" QUIT"
	S ARRAY(3)="E1 S X=2",EXPECTED(3)="E1 SET X=2"
	S ARRAY(4)=" Q",EXPECTED(4)=" QUIT"
	;S EXPECTED(5)=" ;"
	;S EXPECTED(6)="DOIF1() ;"
	;S EXPECTED(7)=" SET Y=1"
	;S EXPECTED(8)=" SET Z=3"
	;S EXPECTED(9)=" DO E1"
	;S EXPECTED(10)=" SET K=0"
	;S EXPECTED(11)=" QUIT 0"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	Q
	;
IF4	;
	N ROU,ARRAY,EXPECTED,ACTUAL
	S ROU="JLITEST1"
	S ARRAY(1)=" I X>4,Y>5 S Y=1,Z=3 I Z=2 D E1 S K=0"
	S EXPECTED(1)=" IF X>4 IF Y>5 SET Y=1 SET Z=3 IF Z=2 DO E1 SET K=0"
	S ARRAY(2)=" Q",EXPECTED(2)=" QUIT"
	S ARRAY(3)="E1 S X=2",EXPECTED(3)="E1 SET X=2"
	S ARRAY(4)=" Q",EXPECTED(4)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	Q
NEWTEST	;
	N ROU,ARRAY,EXPECTED,ACTUAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" D DEBUG^XTMLOG(""COMMANDS"",""XTDEBLIN,XTDEBLVL,""_$NAME(@XTDEBLOC@(""REASONDONE""))_"",""_$NAME(@XTDEBLOC@(""LVL"",XTDEBLVL,""ARGS"",""CURR"")))"
	S EXPECTED(1)=" DO DEBUG^XTMLOG(""COMMANDS"",""XTDEBLIN,XTDEBLVL,""_$NAME(@XTDEBLOC@(""REASONDONE""))_"",""_$NAME(@XTDEBLOC@(""LVL"",XTDEBLVL,""ARGS"",""CURR"")))"
	S ARRAY(2)=" I $G(@XTDEBLOC@(""REASONDONE""))="""" D  D DEBUG^XTMLOG(""COMMANDS1B"",""XTDEBDAT"") I XTDEBDAT S @XTDEBLOC@(""LVL"",XTDEBLVL,""ENTRY"")=""COMMANDS^XTDEBUG"" D INFO^XTMLOG(""EXIT COMMANDS 2"") Q"
	S EXPECTED(2)=" IF $GET(@XTDEBLOC@(""REASONDONE""))="""" DO DODOT1 DO DEBUG^XTMLOG(""COMMANDS1B"",""XTDEBDAT"") IF XTDEBDAT SET @XTDEBLOC@(""LVL"",XTDEBLVL,""ENTRY"")=""COMMANDS^XTDEBUG"" DO INFO^XTMLOG(""EXIT COMMANDS 2"") QUIT"
	S ARRAY(3)=" . N XTDEBNUM,XTDEBVAL S XTDEBDAT=0"
	S ARRAY(4)=" . S XTDEBNUM=$G(@XTDEBLOC@(""LVL"",XTDEBLVL,""ARGS"",""CURR""))+1"
	S ARRAY(5)=" . S XTDEBVAL=$D(@XTDEBLOC@(""LVL"",XTDEBLVL,""XTDEBARG"",""ARGS"",XTDEBNUM))"
	S ARRAY(6)=" . D DEBUG^XTMLOG(""COMMANDS1A"",""XTDEBNUM,XTDEBVAL"")"
	S ARRAY(7)=" . I 'XTDEBVAL,XTDEBNUM>1 Q"
	S ARRAY(8)=" . S XTDEBDAT=$$CHKQUIT^XTDEBUG() ; JLI 051026  ALSO MOVED TO CHEKDONE"
	S ARRAY(9)=" K @XTDEBLOC@(""LVL"",XTDEBLVL,""VALUESDONE"")"
	S ARRAY(10)=" Q"
	S EXPECTED(3)=" KILL @XTDEBLOC@(""LVL"",XTDEBLVL,""VALUESDONE"")"
	S EXPECTED(4)=" QUIT"
	S EXPECTED(5)=" ;"
	S EXPECTED(6)="DODOT1 ;"
	S EXPECTED(7)=" NEW XTDEBNUM,XTDEBVAL"
	S EXPECTED(8)=" SET XTDEBDAT=0"
	S EXPECTED(9)=" SET XTDEBNUM=$GET(@XTDEBLOC@(""LVL"",XTDEBLVL,""ARGS"",""CURR""))+1"
	S EXPECTED(10)=" SET XTDEBVAL=$DATA(@XTDEBLOC@(""LVL"",XTDEBLVL,""XTDEBARG"",""ARGS"",XTDEBNUM))"
	S EXPECTED(11)=" DO DEBUG^XTMLOG(""COMMANDS1A"",""XTDEBNUM,XTDEBVAL"")"
	S EXPECTED(12)=" IF 'XTDEBVAL IF XTDEBNUM>1 QUIT"
	S EXPECTED(13)=" ; JLI 051026  ALSO MOVED TO CHEKDONE"
	S EXPECTED(14)=" SET XTDEBDAT=$$CHKQUIT^XTDEBUG()"
	S EXPECTED(15)=" QUIT"
	;D DEBUG^XTMLOG("ARRAY","ARRAY",1)
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	;D DEBUG^XTMLOG("EXPECTED","EXPECTED",1)
	;D DEBUG^XTMLOG("ACTUAL","ACTUAL",1)
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
NESTDOT	; handle nested do dots
	N ROU,ARRAY,EXPECTED,ACTUAL
	S ROU="JLITEST1"
	S ARRAY(1)=" S X=4 D  S Y=3",EXPECTED(1)=" SET X=4"
	S ARRAY(2)=" . S M=4 D  S N=5"
	S ARRAY(3)=" . . S Z=4"
	S ARRAY(4)=" . S P=2"
	S ARRAY(5)=" S A=2"
	S ARRAY(6)=" Q"
	S EXPECTED(2)=" DO DODOT1"
	S EXPECTED(3)=" SET Y=3"
	S EXPECTED(4)=" SET A=2"
	S EXPECTED(5)=" QUIT"
	S EXPECTED(6)=" ;"
	S EXPECTED(7)="DODOT1 ;"
	S EXPECTED(8)=" SET M=4"
	S EXPECTED(9)=" DO DODOT2"
	S EXPECTED(10)=" SET N=5"
	S EXPECTED(11)=" SET P=2"
	S EXPECTED(12)=" QUIT"
	S EXPECTED(13)=" ;"
	S EXPECTED(14)="DODOT2 ;"
	S EXPECTED(15)=" SET Z=4"
	S EXPECTED(16)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	Q
	;
FORNDOT	;for and do dot commands mixed
	N ROU,ARRAY,EXPECTED,ACTUAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" F TAG=1:1 S X=$T(TABLE+TAG) Q:X=""""  D"
	S ARRAY(2)=" . S TG=$P(X,"";;"",2),TX=$P(X,"";;"",3) Q:TG="""""
	S ARRAY(3)=" . F IX=1:1 S X=$P(TX,"":"",IX) Q:X=""""  D"
	S ARRAY(4)=" . . S S=$P(X,"",""),L=$P(X,"","",2),V=$P(X,"","",3)"
	S ARRAY(5)=" Q"
	S EXPECTED(1)=" FOR TAG=1:1 QUIT:$$DOFOR1()"
	S EXPECTED(2)=" QUIT"
	S EXPECTED(3)=" ;"
	S EXPECTED(4)="DODOT1 ;"
	S EXPECTED(5)=" SET TG=$PIECE(X,"";;"",2)"
	S EXPECTED(6)=" SET TX=$PIECE(X,"";;"",3)"
	S EXPECTED(7)=" QUIT:TG="""""
	S EXPECTED(8)=" FOR IX=1:1 QUIT:$$DOFOR2()"
	S EXPECTED(9)=" QUIT"
	S EXPECTED(10)=" ;"
	S EXPECTED(11)="DODOT2 ;"
	S EXPECTED(12)=" SET S=$PIECE(X,"","")"
	S EXPECTED(13)=" SET L=$PIECE(X,"","",2)"
	S EXPECTED(14)=" SET V=$PIECE(X,"","",3)"
	S EXPECTED(15)=" QUIT"
	S EXPECTED(16)=" ;"
	S EXPECTED(17)="DOFOR1() ;"
	S EXPECTED(18)=" SET X=$TEXT(TABLE+TAG)"
	S EXPECTED(19)=" QUIT:X="""" 1"
	S EXPECTED(20)=" DO DODOT1"
	S EXPECTED(21)=" QUIT 0"
	S EXPECTED(22)=" ;"
	S EXPECTED(23)="DOFOR2() ;"
	S EXPECTED(24)=" SET X=$PIECE(TX,"":"",IX)"
	S EXPECTED(25)=" QUIT:X="""" 1"
	S EXPECTED(26)=" DO DODOT2"
	S EXPECTED(27)=" QUIT 0"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	;D DEBUG^XTMLOG("EXPECTED","EXPECTED",1)
	;D DEBUG^XTMLOG("ACTUAL","ACTUAL",1)
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
MULTFOR	;
	N ROU,ARRAY,EXPECTED,ACTUAL,TESTVAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" F TAG=1:1 S X=$T(TABLE+TAG) Q:X=""""  D  F J=1:1 Q:J>5  S X=X+J"
	S ARRAY(2)=" . F IX=1:1 S X=$P(TX,"":"",IX) Q:X=""""  S X=X+IX"
	S ARRAY(3)=" Q"
	S EXPECTED(1)=" FOR TAG=1:1 QUIT:$$DOFOR1()"
	S EXPECTED(2)=" QUIT"
	S EXPECTED(3)=" ;"
	S EXPECTED(4)="DODOT1 ;"
	S EXPECTED(5)=" FOR IX=1:1 QUIT:$$DOFOR2()"
	S EXPECTED(6)=" QUIT"
	S EXPECTED(7)=" ;"
	S EXPECTED(8)="DOFOR1() ;"
	S EXPECTED(9)=" SET X=$TEXT(TABLE+TAG)"
	S EXPECTED(10)=" QUIT:X="""" 1"
	S EXPECTED(11)=" DO DODOT1"
	S EXPECTED(12)=" FOR J=1:1 QUIT:$$DOFOR3()"
	S EXPECTED(13)=" QUIT 0"
	S EXPECTED(14)=" ;"
	S EXPECTED(15)="DOFOR2() ;"
	S EXPECTED(16)=" SET X=$PIECE(TX,"":"",IX)"
	S EXPECTED(17)=" QUIT:X="""" 1"
	S EXPECTED(18)=" SET X=X+IX"
	S EXPECTED(19)=" QUIT 0"
	S EXPECTED(20)=" ;"
	S EXPECTED(21)="DOFOR3() ;"
	S EXPECTED(22)=" QUIT:J>5 1"
	S EXPECTED(23)=" SET X=X+J"
	S EXPECTED(24)=" QUIT 0"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	;D DEBUG^XTMLOG("EXPECTED","EXPECTED",1)
	;D DEBUG^XTMLOG("ACTUAL","ACTUAL",1)
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
DOLGET	;
	N ROU,ARRAY,EXPECTED,ACTUAL,TESTVAL
	;D FILEINIT^XTMLOG("ZZUTXTMR")
	S ROU="JLITEST1"
	S ARRAY(1)=" G QQ:$G(^DI(.84,0))']"""""
	S ARRAY(2)="C G QQ:$G(^DI(.84,0))']"""" K (DTIME,DUZ) G ^DII"
	S ARRAY(3)="D G QQ:$G(^DI(.84,0))']"""" G ^DII"
	S ARRAY(4)=" ;"
	S ARRAY(5)="QQ W ""ERROR MESSAGE"""
	S ARRAY(6)=" Q"
	S EXPECTED(1)=" GOTO QQ:$GET(^DI(.84,0))']"""""
	S EXPECTED(2)="C GOTO QQ:$GET(^DI(.84,0))']"""""
	S EXPECTED(3)=" KILL (DTIME,DUZ)"
	S EXPECTED(4)=" GOTO ^DII"
	S EXPECTED(5)="D GOTO QQ:$GET(^DI(.84,0))']"""""
	S EXPECTED(6)=" GOTO ^DII"
	S EXPECTED(7)=" ;"
	S EXPECTED(8)="QQ WRITE ""ERROR MESSAGE"""
	S EXPECTED(9)=" QUIT"
	D SAVEROU(ROU,.ARRAY)
	D ENTRY^XTMREDO(ROU,$G(XTMLOG))
	D LOADROU("ZZ"_$$DATESTR()_"JLITEST1","ACTUAL")
	D CHKARRAY(.EXPECTED,.ACTUAL)
	;D ENDLOG^XTMLOG("ZZUTXTMR")
	Q
	;
DATESTR()	; returns 6 digit date string
	Q $E($$NOW^XLFDT(),2,7)
	;
CHKARRAY(EXPECTED,ACTUAL)	;
	N NEXPECT,NACTUAL,I,NMAX
	F I=1:1 I '$D(EXPECTED(I)) S NEXPECT=I-1 Q
	F I=1:1 I '$D(ACTUAL(I)) S NACTUAL=I-1 Q
	S NMAX=$S(NEXPECT>NACTUAL:NEXPECT,1:NACTUAL)
	D CHKEQ^XTMUNIT(NEXPECT,NACTUAL,"unmatched array lengths")
	F I=1:1:NMAX D CHKEQ^XTMUNIT($G(EXPECTED(I)),$G(ACTUAL(I,0)),"unmatched array value for "_I)
	Q
	;
XTROU	;
	;;ZZUTRED1
XTENT	;
	;;NRMLDO;check normal DO commands
	;;POSTDO1;test post conditonal DO statements
	;;POSTDO2;test post conditonal DO statements
	;;IF1;test IF statement with single command following
	;;IFCOND1;test conditional command statements
	;;IFCOND2;
	;;IF2;test IF with multiple commands, no special handling
	;;IF3;IF with multiple arguments
	;;IF4;multiple IF statements
	;;NEWTEST;test from XTDEBUG1
	;;NESTDOT;test nested DO DOT (argumentless DOs)
	;;FORNDOT;test combined FOR and DO DOT code
	;;MULTFOR;test multiple FOR commands
	;;DOLGET;get $GET correct

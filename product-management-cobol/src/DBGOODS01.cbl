       IDENTIFICATION         DIVISION.
       PROGRAM-ID.            DBGOODS01.
       ENVIRONMENT            DIVISION.
       INPUT-OUTPUT           SECTION.
       FILE-CONTROL.
           SELECT IN-ITEM-FILE ASSIGN TO
             "ITEMFILE.txt"
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS  IS IN-ITEM-SATAUS.
           SELECT IN-CATEGORY-FILE ASSIGN TO
             "CATEGORYFILE.txt"
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS  IS IN-CATEGORY-SATAUS.
       DATA                   DIVISION.
       FILE                   SECTION.
       FD  IN-ITEM-FILE.
       01  IN-ITEM.
         03 IN-ITEM-ID              PIC X(4).
         03 IN-ITEM-NAME            PIC X(30).
         03 IN-ITEM-QUANTITY        PIC 9(4).
         03 IN-ITEM-PRICE           PIC 9(9).
       FD  IN-CATEGORY-FILE.
       01  IN-CATEGORY.
         03 IN-CATEGORY-ITEM-ID     PIC X(4).
         03 IN-CATEGORY-ID          PIC X(4).
         03 IN-CATEGORY-NAME        PIC X(30).
       WORKING-STORAGE        SECTION.
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      ***  埋込SQL宣言節
       01  DB-CONECT.
         03 DBNAME                  PIC X(10).
         03 USERNAME                PIC X(10).
         03 PASSWD                  PIC X(10).
      ***  ITEMのホスト変数定義
       01  D00-ITEM.
         03 D00-ITEM-ID             PIC X(4).
         03 D00-ITEM-RENBN          PIC 9(5).
         03 D00-ITEM-NAME           PIC X(30).
         03 D00-ITEM-QUANTITY       PIC 9(4).
         03 D00-ITEM-PRICE          PIC 9(9).
         03 D00-ITEM-UPDATE-DATE    PIC X(8).
      ***  ITEMのホスト変数の定義
       01  D01-ITEM.
         03 D01-ITEM-RENBN          PIC 9(5).
      ***  CATEGORYのホスト変数の定義
       01  D02-CATEGORY.
         03 D02-CATEGORY-ITEM-ID    PIC X(4).
         03 D02-CATEGORY-RENBN      PIC 9(5).
         03 D02-CATEGORY-ID         PIC X(4).
         03 D02-CATEGORY-NAME       PIC X(30).
         03 D02-CATEGORY-UPDATE-DATE
                                    PIC X(8).
      ***  CATEGORYのホスト変数の定義
       01  D03-CATEGORY.
         03 D03-CATEGORY-RENBN      PIC 9(5).
           EXEC SQL END DECLARE SECTION END-EXEC.
      *** 共通領域の定義
           EXEC SQL INCLUDE SQLCA END-EXEC.
      *
      ************************************************
      * ワークエリア
      ************************************************
       01  STTS.
         03 IN-ITEM-SATAUS          PIC X(2).
         03 IN-CATEGORY-SATAUS      PIC X(2).
      ***  終了フラグ
       01  END-FLG.
         03 IN-ITEM-END-FLG         PIC X(3).
         03 IN-CATEGORY-END-FLG     PIC X(3).
      ***  回数
       01  CNT.
         03 IN-ITEM-COUNT           PIC S9(9) COMP-3.
         03 IN-CATEGORY-COUNT       PIC S9(9) COMP-3.
         03 ITEM-INSERT-COUNT       PIC S9(9) COMP-3.
         03 CATEGORY-INSERT-COUNT   PIC S9(9) COMP-3.
      ***  I-O区分
       01  WK-FL-IO-KBN             PIC X(8).
      ***  DBエラー用作業領域
       01  WK-DB-ERR-AREA.
         03 WK-DB-NAME              PIC X(30).
         03 WK-DB-SQL-STS           PIC X(15).
         03 WK-DB-SQL-CD            PIC S9(5).
         03 WK-DB-ERR-FLG           PIC X(5).
      ***  更新日付作業領域
       01  WK-UPDATE-DATE.
         03 WK-UPDATE-DATE-YYYY     PIC X(4).
         03 WK-UPDATE-DATE-MM       PIC X(2).
         03 WK-UPDATE-DATE-DD       PIC X(2).
      ***  リターンコード
       01  RETURN-CODE1             PIC S9(9)
                                    VALUE +000000000.
       01  RETURN-CODE2             PIC S9(9)
                                    VALUE +000000000.
       01  RETURN-CODE3             PIC S9(9)
                                    VALUE +000000000.
      ************************************************
      * コンスタントエリア
      ************************************************
       01  START-MSG.
         03 FILLER            PIC X(3) VALUE "***".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 PROGRAMID         PIC X(9) VALUE "DBGOODS01".
         03 FILLER            PIC X(1) VALUE SPACE.
         03 FILLER            PIC X(5) VALUE "START".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 FILLER            PIC X(3) VALUE "***".
       01  END-MSG.
         03 FILLER            PIC X(3) VALUE "***".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 PROGRAMID         PIC X(9) VALUE "DBGOODS01".
         03 FILLER            PIC X(1) VALUE SPACE.
         03 FILLER            PIC X(3) VALUE "END".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 FILLER            PIC X(3) VALUE "***".
      * 入出力件数メッセージ
       01  RECORD-COUNT-MSG-1.
         03 FILLER            PIC X(12)
                              VALUE "IN-ITEM     ".
         03 FILLER            PIC X(10)
                              VALUE "  RECORD  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
       01  RECORD-COUNT-MSG-2.
         03 FILLER            PIC X(12)
                              VALUE "IN-CATEGORY ".
         03 FILLER            PIC X(10)
                              VALUE "  RECORD  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
      * DB件数メッセージ
       01  DB-COUNT-MSG-1.
         03 FILLER            PIC X(12)
                              VALUE "ITEM        ".
         03 FILLER            PIC X(10)
                              VALUE "  INSERT  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
       01  DB-COUNT-MSG-2.
         03 FILLER            PIC X(12)
                              VALUE "CATEGORY    ".
         03 FILLER            PIC X(10)
                              VALUE "  INSERT  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
      * 件表示
       01  KEN                PIC X(3)
                              VALUE "件".
       01  CNS-MESSAGE.
         03 MESSAGE1          PIC X(13) VALUE "FILE-OPEN-ERR".
         03 MESSAGE2          PIC X(14) VALUE "FILE-CLOSE-ERR".
       01  CNS-SQL-NOF        PIC S9(5) VALUE +100.
      *
       PROCEDURE              DIVISION.
      ************************************************
      * メイン
      ************************************************
       MAIN                   SECTION.
       MAIN-000.
      *
           PERFORM INIT-PROC.
      *
           PERFORM IN-ITEM-READ.
           PERFORM UNTIL IN-ITEM-END-FLG = "END"
             PERFORM ITEM-PROC
             PERFORM IN-ITEM-READ
           END-PERFORM.
      *
           PERFORM IN-CATEGORY-READ.
           PERFORM UNTIL IN-CATEGORY-END-FLG = "END"
             PERFORM CATEGORY-PROC
             PERFORM IN-CATEGORY-READ
           END-PERFORM.
      *
           PERFORM END-PROC.
      *
           EXIT PROGRAM.
      *
      ************************************************
      * 初期処理
      ************************************************
       INIT-PROC               SECTION.
       INIT-PROC-000.
      *
           DISPLAY START-MSG               UPON SYSOUT.
      *
           PERFORM SYOKIKA-PROC.
      *
           MOVE FUNCTION CURRENT-DATE TO WK-UPDATE-DATE.
      *
           PERFORM DB-CONNECT.
      *
           MOVE "OPEN"   TO    WK-FL-IO-KBN.
           OPEN INPUT IN-ITEM-FILE IN-CATEGORY-FILE.
           IF IN-ITEM-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE1            UPON SYSOUT
               PERFORM IN-ITEM-ERR
           END-IF.
           IF IN-CATEGORY-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE1            UPON SYSOUT
               PERFORM IN-CATEGORY-ERR
           END-IF.
      *
       INIT-PROC-999.
           EXIT.
      *
      ************************************************
      * 終了処理
      ************************************************
       END-PROC                SECTION.
       END-PROC-000.
      *
      * DB-COMMIT処理
           PERFORM DB-COMMIT-PROC.
      * 件数表示
           DISPLAY RECORD-COUNT-MSG-1
             IN-ITEM-COUNT KEN            UPON SYSOUT.
           DISPLAY RECORD-COUNT-MSG-2
             IN-CATEGORY-COUNT KEN        UPON SYSOUT.
           DISPLAY DB-COUNT-MSG-1
             ITEM-INSERT-COUNT KEN        UPON SYSOUT.
           DISPLAY DB-COUNT-MSG-2
             CATEGORY-INSERT-COUNT KEN    UPON SYSOUT.
      *
           INITIALIZE WK-FL-IO-KBN.
           MOVE "CLOSE"   TO    WK-FL-IO-KBN.
           CLOSE IN-ITEM-FILE IN-CATEGORY-FILE.
           IF IN-ITEM-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE2            UPON SYSOUT
               PERFORM IN-ITEM-ERR
           END-IF.
           IF IN-CATEGORY-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE2            UPON SYSOUT
               PERFORM IN-CATEGORY-ERR
           END-IF.
      *
           CALL "DBGOODS02".
      *
           DISPLAY END-MSG                 UPON SYSOUT.
      *
       END-PROC-999.
           EXIT.
      *
      ************************************************
      * 初期化処理
      ************************************************
       SYOKIKA-PROC            SECTION.
       SYOKIKA-PROC-000.
      *
      ***  項目初期化
           INITIALIZE IN-ITEM
                      IN-CATEGORY
                      D00-ITEM
                      D01-ITEM
                      D02-CATEGORY
                      D03-CATEGORY
                      STTS
                      END-FLG
                      CNT
                      WK-DB-ERR-AREA
                      WK-UPDATE-DATE
                      WK-FL-IO-KBN.
      *
       SYOKIKA-PROC-999.
           EXIT.
      *
      ************************************************
      * IN-ITEM-入力処理
      ************************************************
       IN-ITEM-READ            SECTION.
       IN-ITEM-READ-000.
      *
           MOVE "READ" TO WK-FL-IO-KBN.
      *
           READ IN-ITEM-FILE
             AT END
               MOVE "END" TO IN-ITEM-END-FLG
             NOT AT END
               CONTINUE
           END-READ.
      *
           IF IN-ITEM-SATAUS = "00" OR "10"
           THEN
             CONTINUE
           ELSE
             PERFORM IN-ITEM-ERR
           END-IF.
      *
           IF IN-ITEM-END-FLG = "END"
             THEN
               CONTINUE
             ELSE
               COMPUTE IN-ITEM-COUNT = IN-ITEM-COUNT + 1
           END-IF.
      *
       IN-ITEM-READ-999.
           EXIT.
      *
      ************************************************
      * IN-CATEGORY-入力処理
      ************************************************
       IN-CATEGORY-READ            SECTION.
       IN-CATEGORY-READ-000.
      *
           INITIALIZE WK-FL-IO-KBN.
           MOVE "READ" TO WK-FL-IO-KBN.
      *
           READ IN-CATEGORY-FILE
             AT END
               MOVE "END" TO IN-CATEGORY-END-FLG
             NOT AT END
               CONTINUE
           END-READ.
      *
           IF IN-CATEGORY-SATAUS = "00" OR "10"
           THEN
             CONTINUE
           ELSE
             PERFORM IN-CATEGORY-ERR
           END-IF.
      *
           IF IN-CATEGORY-END-FLG = "END"
             THEN
               CONTINUE
             ELSE
               COMPUTE IN-CATEGORY-COUNT = IN-CATEGORY-COUNT + 1
           END-IF.
      *
       IN-CATEGORY-READ-999.
           EXIT.
      *
      ************************************************
      * ITEM追加処理
      ************************************************
       ITEM-PROC            SECTION.
       ITEM-PROC-000.
      *
           MOVE "ITEM"           TO WK-DB-NAME.
           MOVE "SELECT"         TO WK-DB-SQL-STS.
      *
           INITIALIZE D00-ITEM
                      D01-ITEM.
      *
           MOVE IN-ITEM-ID       TO D00-ITEM-ID.
           MOVE IN-ITEM-NAME     TO D00-ITEM-NAME.
           MOVE IN-ITEM-QUANTITY TO D00-ITEM-QUANTITY.
           MOVE IN-ITEM-PRICE    TO D00-ITEM-PRICE.
           MOVE WK-UPDATE-DATE   TO D00-ITEM-UPDATE-DATE.
      *
           EXEC SQL
             SELECT COALESCE(MAX(item_renbn), 0)
             INTO :D01-ITEM-RENBN
             FROM item
             GROUP BY item_id
             HAVING item_id = :D00-ITEM-ID
           END-EXEC.
      *
           EVALUATE SQLCODE
             WHEN ZERO
               IF D01-ITEM-RENBN <= 99999
                 THEN
                   COMPUTE D00-ITEM-RENBN = D00-ITEM-RENBN +
                           D01-ITEM-RENBN + 1
                 ELSE
                   PERFORM DB-ERROR-RTN
               END-IF
             WHEN CNS-SQL-NOF
               COMPUTE D00-ITEM-RENBN = D00-ITEM-RENBN + 1
             WHEN OTHER
               PERFORM DB-ERROR-RTN
           END-EVALUATE.
      *
           INITIALIZE WK-DB-ERR-AREA.
           MOVE "ITEM"           TO WK-DB-NAME.
           MOVE "INSERT"         TO WK-DB-SQL-STS.
      *
           EXEC SQL
             INSERT INTO item
             VALUES (:D00-ITEM-ID,
             :D00-ITEM-RENBN,
             :D00-ITEM-NAME,
             :D00-ITEM-QUANTITY,
             :D00-ITEM-PRICE,
             TO_DATE(:D00-ITEM-UPDATE-DATE,'YYYYMMDD'))
           END-EXEC.
      *
           IF SQLCODE = ZERO OR CNS-SQL-NOF
             THEN
               COMPUTE ITEM-INSERT-COUNT = ITEM-INSERT-COUNT +
                       SQLERRD(3)
             ELSE
               PERFORM DB-ERROR-RTN
           END-IF.
      *
       ITEM-PROC-999.
           EXIT.
      *
      ************************************************
      * CATEGORY追加処理
      ************************************************
       CATEGORY-PROC            SECTION.
       CATEGORY-PROC-000.
      *
           INITIALIZE WK-DB-ERR-AREA
                      D02-CATEGORY
                      D03-CATEGORY.
      *
           MOVE "CATEGORY"       TO WK-DB-NAME.
           MOVE "SELECT"         TO WK-DB-SQL-STS.
      *
           MOVE IN-CATEGORY-ITEM-ID
                                 TO D02-CATEGORY-ITEM-ID.
           MOVE IN-CATEGORY-ID   TO D02-CATEGORY-ID.
           MOVE IN-CATEGORY-NAME TO D02-CATEGORY-NAME.
           MOVE WK-UPDATE-DATE   TO D02-CATEGORY-UPDATE-DATE.
      *
           EXEC SQL
             SELECT COALESCE(MAX(category_renbn), 0)
             INTO :D02-CATEGORY-RENBN
             FROM category
             GROUP BY item_id
             HAVING item_id = :D02-CATEGORY-ITEM-ID
           END-EXEC.
      *
           EVALUATE SQLCODE
             WHEN ZERO
               IF D03-CATEGORY-RENBN <= 99999
                 THEN
                   COMPUTE D02-CATEGORY-RENBN = D02-CATEGORY-RENBN +
                           D03-CATEGORY-RENBN + 1
                 ELSE
                   PERFORM DB-ERROR-RTN
               END-IF
             WHEN CNS-SQL-NOF
               COMPUTE D02-CATEGORY-RENBN = D02-CATEGORY-RENBN + 1
             WHEN OTHER
               PERFORM DB-ERROR-RTN
           END-EVALUATE.
      *
           INITIALIZE WK-DB-ERR-AREA.
      *
           MOVE "CATEGORY"       TO WK-DB-NAME.
           MOVE "INSERT"         TO WK-DB-SQL-STS.
      *
           EXEC SQL
             INSERT INTO category
             VALUES (:D02-CATEGORY-ITEM-ID,
             :D02-CATEGORY-RENBN,
             :D02-CATEGORY-ID,
             :D02-CATEGORY-NAME,
             TO_DATE(:D02-CATEGORY-UPDATE-DATE,'YYYYMMDD'))
           END-EXEC.
      *
           IF SQLCODE = ZERO OR CNS-SQL-NOF
             THEN
               COMPUTE CATEGORY-INSERT-COUNT =
               CATEGORY-INSERT-COUNT + SQLERRD(3)
             ELSE
               PERFORM DB-ERROR-RTN
           END-IF.
      *
       CATEGORY-PROC-999.
           EXIT.
      *
      ************************************************
      * DB接続
      ************************************************
       DB-CONNECT              SECTION.
       DB-CONNECT-000.
      *
      ***  DB接続
           MOVE SPACE              TO  WK-DB-NAME.
           MOVE "CONNECT"          TO  WK-DB-SQL-STS.
           MOVE  "testdb@db"       TO  DBNAME.
           MOVE  "postgres"        TO  USERNAME.
           MOVE  SPACE             TO  PASSWD.
           EXEC SQL
               CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
           END-EXEC.
      *
           IF SQLCODE NOT = ZERO
             THEN
               PERFORM DB-ERROR-RTN
             ELSE
               CONTINUE
           END-IF.
      *
       DB-CONNECT-999.
           EXIT.
      *
      ************************************************
      * ＲＯＬＬＢＡＣＫ処理
      ************************************************
       DB-ROLLBACK-PROC          SECTION.
       DB-ROLLBACK-PROC-000.
      *
      ***  ＲＯＬＬＢＡＣＫ処理
           EXEC SQL
             ROLLBACK
           END-EXEC.
           DISPLAY "ROLLBACK"            UPON SYSOUT.
      *
       DB-ROLLBACK-PROC-999.
           EXIT.
      *
      ************************************************
      * ＣＯＭＭＩＴ処理
      ************************************************
       DB-COMMIT-PROC          SECTION.
       DB-COMMIT-PROC-000.
      *
      ***  ＣＯＭＭＩＴ処理
           EXEC SQL
             COMMIT
           END-EXEC.
      *
       DB-COMMIT-PROC-999.
           EXIT.
      *
      ************************************************
      * ＤＢエラー
      ************************************************
       DB-ERROR-RTN             SECTION.
       DB-ERROR-RTN-000.
      *
      ***  ＤＢエラー
           MOVE "DBERR"        TO    WK-DB-ERR-FLG.
           DISPLAY "WK-DB-ERR-FLG:"  WK-DB-ERR-FLG    UPON SYSOUT.
           DISPLAY "WK-DB-NAME:"     WK-DB-NAME       UPON SYSOUT.
           DISPLAY "WK-DB-SQL-STS:"  WK-DB-SQL-STS    UPON SYSOUT.
           DISPLAY "SQLCODE:" SQLCODE                 UPON SYSOUT.
           DISPLAY "DB ERROR"                         UPON SYSOUT.
           PERFORM DB-ROLLBACK-PROC.
           MOVE  9              TO  RETURN-CODE1.
           DISPLAY "RETURN-CODE:" RETURN-CODE1        UPON SYSOUT.
      *
       DB-ERROR-RTN-999.
           GOBACK.
      *
      ************************************************
      * IN-ITEM I/Oエラー
      ************************************************
       IN-ITEM-ERR             SECTION.
       IN-ITEM-ERR-000.
      *
      ***  I/Oエラー
           IF WK-FL-IO-KBN = "OPEN"
             THEN
               DISPLAY "WK-FL-IO-KBN:" WK-FL-IO-KBN   UPON SYSOUT
               DISPLAY "IN-ITEM-SATAUS" IN-ITEM-SATAUS
                                                      UPON SYSOUT
               DISPLAY "IN-ITEM I/Oエラー"            UPON SYSOUT
             ELSE
               MOVE SPACE       TO  WK-DB-NAME
               MOVE 'ROLLBACK'  TO  WK-DB-SQL-STS
               DISPLAY "WK-FL-IO-KBN:" WK-FL-IO-KBN   UPON SYSOUT
               DISPLAY "IN-ITEM-SATAUS" IN-ITEM-SATAUS
                                                      UPON SYSOUT
               DISPLAY "WK-DB-NAME:" WK-DB-NAME       UPON SYSOUT
               DISPLAY "WK-DB-SQL-STS:" WK-DB-SQL-STS UPON SYSOUT
               DISPLAY "IN-ITEM I/Oエラー"            UPON SYSOUT
               PERFORM DB-ROLLBACK-PROC
           END-IF.
           MOVE  9              TO  RETURN-CODE2.
           DISPLAY "RETURN-CODE:" RETURN-CODE2        UPON SYSOUT.
      *
       IN-ITEM-ERR-999.
           GOBACK.
      *
      ************************************************
      * IN-CATEGORY I/Oエラー
      ************************************************
       IN-CATEGORY-ERR             SECTION.
       IN-CATEGORY-ERR-000.
      *
      ***  I/Oエラー
           IF WK-FL-IO-KBN = "OPEN"
             THEN
               DISPLAY "WK-FL-IO-KBN:" WK-FL-IO-KBN   UPON SYSOUT
               DISPLAY "IN-CATEGORY-SATAUS" IN-CATEGORY-SATAUS
                                                      UPON SYSOUT
               DISPLAY "IN-CATEGORY I/Oエラー"        UPON SYSOUT
             ELSE
               MOVE SPACE       TO  WK-DB-NAME
               MOVE 'ROLLBACK'  TO  WK-DB-SQL-STS
               DISPLAY "WK-FL-IO-KBN:" WK-FL-IO-KBN   UPON SYSOUT
               DISPLAY "IN-CATEGORY-SATAUS" IN-CATEGORY-SATAUS
                                                      UPON SYSOUT
               DISPLAY "WK-DB-NAME:" WK-DB-NAME       UPON SYSOUT
               DISPLAY "WK-DB-SQL-STS:" WK-DB-SQL-STS UPON SYSOUT
               DISPLAY "IN-CATEGORY I/Oエラー"        UPON SYSOUT
               PERFORM DB-ROLLBACK-PROC
           END-IF.
           MOVE  9              TO  RETURN-CODE3.
           DISPLAY  "RETURN-CODE:" RETURN-CODE3       UPON SYSOUT.
      *
       IN-CATEGORY-ERR-999.
           GOBACK.
      *

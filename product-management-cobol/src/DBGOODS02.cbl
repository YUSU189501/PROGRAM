       IDENTIFICATION         DIVISION.
       PROGRAM-ID.            DBGOODS02.
       ENVIRONMENT            DIVISION.
       DATA                   DIVISION.
       WORKING-STORAGE        SECTION.
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      ***  埋込SQL宣言節
       01  DB-CONECT.
         03 DBNAME                  PIC X(10).
         03 USERNAME                PIC X(10).
         03 PASSWD                  PIC X(10).
      ***  GOODSのホスト変数の定義
       01  D00-GOODS.
         03 D00-GOODS-ITEM-ID       PIC X(4).
         03 D00-GOODS-ITEM-NAME     PIC X(30).
         03 D00-GOODS-QUANTITY      PIC 9(4).
         03 D00-GOODS-PRICE         PIC 9(9).
         03 D00-GOODS-CATEGORY-ID   PIC X(4).
         03 D00-GOODS-CATEGORY-NAME PIC X(30).
      ***  GOODSのホスト変数の定義
       01  D01-GOODS.
         03 D01-GOODS-ITEM-ID       PIC X(4).
         03 D01-GOODS-RENBN         PIC 9(5).
         03 D01-GOODS-ITEM-NAME     PIC X(30).
         03 D01-GOODS-QUANTITY      PIC 9(4).
         03 D01-GOODS-PRICE         PIC 9(9).
         03 D01-GOODS-CATEGORY-ID   PIC X(4).
         03 D01-GOODS-CATEGORY-NAME PIC X(30).
         03 D01-GOODS-UPDATE-DATE   PIC X(8).
      ***  GOODSのホスト変数の定義
       01  D02-GOODS.
         03 D02-GOODS-RENBN         PIC 9(5).
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
         03 JOIN-FETCH-COUNT        PIC S9(9) COMP-3.
         03 JOIN-FETCH-COUNT-A      PIC S9(9) COMP-3.
         03 GOODS-INSERT-COUNT      PIC S9(9) COMP-3.
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
      ************************************************
      * コンスタントエリア
      ************************************************
       01  START-MSG.
         03 FILLER            PIC X(3) VALUE "***".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 PROGRAMID         PIC X(9) VALUE "DBGOODS02".
         03 FILLER            PIC X(1) VALUE SPACE.
         03 FILLER            PIC X(5) VALUE "START".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 FILLER            PIC X(3) VALUE "***".
       01  END-MSG.
         03 FILLER            PIC X(3) VALUE "***".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 PROGRAMID         PIC X(9) VALUE "DBGOODS02".
         03 FILLER            PIC X(1) VALUE SPACE.
         03 FILLER            PIC X(3) VALUE "END".
         03 FILLER            PIC X(2) VALUE ALL SPACE.
         03 FILLER            PIC X(3) VALUE "***".
       01  DB-COUNT-MSG-1.
         03 FILLER            PIC X(12)
                              VALUE "JOIN        ".
         03 FILLER            PIC X(10)
                              VALUE "  FETCH   ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
       01  DB-COUNT-MSG-2.
         03 FILLER            PIC X(12)
                              VALUE "GOODS       ".
         03 FILLER            PIC X(10)
                              VALUE "  INSERT  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
      * 件表示
       01  KEN                PIC X(3)
                              VALUE "件".
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
           PERFORM JOIN-CSROP-PROC.
           PERFORM JOIN-FETCH-PROC.
           PERFORM WITH TEST BEFORE
             UNTIL WK-DB-SQL-CD = CNS-SQL-NOF
             PERFORM GOODS-INSERT-PROC
             PERFORM JOIN-FETCH-PROC
           END-PERFORM.
           PERFORM JOIN-CSRCL-PROC.
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
           DISPLAY DB-COUNT-MSG-1
             JOIN-FETCH-COUNT KEN         UPON SYSOUT.
           DISPLAY DB-COUNT-MSG-2
             GOODS-INSERT-COUNT KEN       UPON SYSOUT.
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
           INITIALIZE D00-GOODS
                      D01-GOODS
                      D02-GOODS
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
      * カーソルオープン処理
      ************************************************
       JOIN-CSROP-PROC          SECTION.
       JOIN-CSROP-PROC-000.
      *
           INITIALIZE WK-DB-ERR-AREA.
      *
           MOVE "GOODS"         TO WK-DB-NAME.
           MOVE "OPEN CURSOR"   TO WK-DB-SQL-STS.
      *
           EXEC SQL
             DECLARE "CUR00" CURSOR FOR
             SELECT
               i.item_id,
               i.item_name,
               c.category_id,
               c.category_name,
               COALESCE(SUM(i.quantity), 0),
               COALESCE(SUM(i.price), 0)
             FROM
               item i
             JOIN category c
             ON   i.item_id = c.item_id
             AND  i.item_renbn = c.category_renbn
             GROUP BY
               i.item_id,
               i.item_name,
               c.category_id,
               c.category_name
             ORDER BY
               i.item_id,
               c.category_id
           END-EXEC.
      *
           EXEC SQL
             OPEN "CUR00"
           END-EXEC.
      *
       JOIN-CSROP-PROC-999.
           EXIT.
      *
      ************************************************
      * JOIN-FETCH処理
      ************************************************
       JOIN-FETCH-PROC          SECTION.
       JOIN-FETCH-PROC-000.
      *
           INITIALIZE WK-DB-ERR-AREA
                      D00-GOODS.
      *
           MOVE "GOODS"         TO WK-DB-NAME.
           MOVE "FETCH"         TO WK-DB-SQL-STS.
      *
           EXEC SQL
             FETCH "CUR00"
             INTO
               :D00-GOODS-ITEM-ID,
               :D00-GOODS-ITEM-NAME,
               :D00-GOODS-CATEGORY-ID,
               :D00-GOODS-CATEGORY-NAME,
               :D00-GOODS-QUANTITY,
               :D00-GOODS-PRICE
           END-EXEC.
      *
           IF SQLCODE = ZERO OR CNS-SQL-NOF
             THEN
               MOVE SQLERRD(3) TO JOIN-FETCH-COUNT-A
             ELSE
               PERFORM DB-ERROR-RTN
           END-IF.
      *
           IF SQLCODE = CNS-SQL-NOF
             THEN
               MOVE CNS-SQL-NOF TO WK-DB-SQL-CD
             ELSE
               CONTINUE
           END-IF.
      *
       JOIN-FETCH-PROC-999.
           EXIT.
      *
      ***********************************************
      * 物品管理テーブル追加処理
      ***********************************************
       GOODS-INSERT-PROC        SECTION.
       GOODS-INSERT-PROC-000.
      *
           INITIALIZE WK-DB-ERR-AREA
                      D01-GOODS
                      D02-GOODS.
      *
           MOVE "GOODS"        TO WK-DB-NAME.
           MOVE "SELECT"       TO WK-DB-SQL-STS.
      *
           MOVE D00-GOODS-ITEM-ID
                               TO D01-GOODS-ITEM-ID.
           MOVE D00-GOODS-ITEM-NAME
                               TO D01-GOODS-ITEM-NAME.
           MOVE D00-GOODS-CATEGORY-ID
                               TO D01-GOODS-CATEGORY-ID.
           MOVE D00-GOODS-CATEGORY-NAME
                               TO D01-GOODS-CATEGORY-NAME.
           MOVE D00-GOODS-QUANTITY
                               TO D01-GOODS-QUANTITY.
           MOVE D00-GOODS-PRICE
                               TO D01-GOODS-PRICE.
           MOVE WK-UPDATE-DATE TO D01-GOODS-UPDATE-DATE.
      *
           EXEC SQL
             SELECT COALESCE(MAX(GOODS_renbn), 0)
             INTO :D02-GOODS-RENBN
             FROM goods
             GROUP BY item_id
             HAVING item_id = :D01-GOODS-ITEM-ID
           END-EXEC.
      *
           EVALUATE SQLCODE
             WHEN ZERO
               IF D02-GOODS-RENBN <= 99999
                 THEN
                   COMPUTE D01-GOODS-RENBN = D01-GOODS-RENBN +
                           D02-GOODS-RENBN + 1
                 ELSE
                   PERFORM DB-ERROR-RTN
               END-IF
             WHEN CNS-SQL-NOF
               COMPUTE D01-GOODS-RENBN = D01-GOODS-RENBN + 1
             WHEN OTHER
               PERFORM DB-ERROR-RTN
           END-EVALUATE.
      *
           INITIALIZE WK-DB-ERR-AREA.
           MOVE "GOODS"        TO WK-DB-NAME.
           MOVE "INSERT"       TO WK-DB-SQL-STS.
      *
           EXEC SQL
             INSERT INTO GOODS
             VALUES (:D01-GOODS-ITEM-ID,
             :D01-GOODS-RENBN,
             :D01-GOODS-ITEM-NAME,
             :D01-GOODS-CATEGORY-ID,
             :D01-GOODS-CATEGORY-NAME,
             :D01-GOODS-QUANTITY,
             :D01-GOODS-PRICE,
             TO_DATE(:D01-GOODS-UPDATE-DATE,'YYYYMMDD'))
           END-EXEC.
      *
           IF SQLCODE = ZERO OR CNS-SQL-NOF
             THEN
               COMPUTE GOODS-INSERT-COUNT =
                       GOODS-INSERT-COUNT + SQLERRD(3)
             ELSE
               PERFORM DB-ERROR-RTN
           END-IF.
      *
       GOODS-INSERT-PROC-999.
           EXIT.
      *
      ************************************************
      * カーソルクローズ処理
      ************************************************
       JOIN-CSRCL-PROC        SECTION.
       JOIN-CSRCL-PROC-000.
      *
           INITIALIZE WK-DB-ERR-AREA.
           MOVE "GOODS"         TO WK-DB-NAME.
           MOVE "CLOSE CURSOR"  TO WK-DB-SQL-STS.
      *
           EXEC SQL
             CLOSE "CUR00"
           END-EXEC.
      *
           COMPUTE JOIN-FETCH-COUNT  =
           JOIN-FETCH-COUNT + JOIN-FETCH-COUNT-A.
      *
       JOIN-CSRCL-PROC-999.
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

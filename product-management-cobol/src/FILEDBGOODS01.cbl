       IDENTIFICATION         DIVISION.
       PROGRAM-ID.            FILEDBGOODS01.
       ENVIRONMENT            DIVISION.
       INPUT-OUTPUT           SECTION.
       FILE-CONTROL.
           SELECT OUT-ITEM-FILE ASSIGN TO
             "ITEMFILE.txt"
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS  IS OUT-ITEM-SATAUS.
           SELECT OUT-CATEGORY-FILE ASSIGN TO
             "CATEGORYFILE.txt"
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS  IS OUT-CATEGORY-SATAUS.
       DATA                   DIVISION.
       FILE                   SECTION.
       FD  OUT-ITEM-FILE.
       01  OUT-ITEM.
         03 OUT-ITEM-ID             PIC X(4).
         03 OUT-ITEM-NAME           PIC X(30).
         03 OUT-ITEM-QUANTITY       PIC 9(4).
         03 OUT-ITEM-PRICE          PIC 9(9).
       FD  OUT-CATEGORY-FILE.
       01  OUT-CATEGORY.
         03 OUT-CATEGORY-ITEM-ID    PIC X(4).
         03 OUT-CATEGORY-ID         PIC X(4).
         03 OUT-CATEGORY-NAME       PIC X(30).
       WORKING-STORAGE        SECTION.
      *** 共通領域の定義
           EXEC SQL INCLUDE SQLCA END-EXEC.
      ************************************************
      * ワークエリア
      ************************************************
       01  STTS.
         03 OUT-ITEM-SATAUS         PIC X(2).
         03 OUT-CATEGORY-SATAUS     PIC X(2).
      ***  回数
       01  CNT.
         03 OUT-ITEM-COUNT          PIC S9(9) COMP-3.
         03 OUT-CATEGORY-COUNT      PIC S9(9) COMP-3.
      ***  I-O区分
       01  WK-FL-IO-KBN             PIC X(8).
      ***  日付
       01  WK-UPDATE-DATE.
         03 WK-UPDATE-DATE-YYYY     PIC X(4).
         03 WK-UPDATE-DATE-MM       PIC X(2).
         03 WK-UPDATE-DATE-DD       PIC X(2).
      ************************************************
      * コンスタントエリア
      ************************************************
       01  START-MSG.
         03 FILLER            PIC X(3)  VALUE "***".
         03 FILLER            PIC X(2)  VALUE ALL SPACE.
         03 PROGRAMID         PIC X(13) VALUE "FILEDBGOODS01".
         03 FILLER            PIC X(1)  VALUE SPACE.
         03 FILLER            PIC X(5)  VALUE "START".
         03 FILLER            PIC X(2)  VALUE ALL SPACE.
         03 FILLER            PIC X(3)  VALUE "***".
       01  END-MSG.
         03 FILLER            PIC X(3)  VALUE "***".
         03 FILLER            PIC X(2)  VALUE ALL SPACE.
         03 PROGRAMID         PIC X(13) VALUE "FILEDBGOODS01".
         03 FILLER            PIC X(1)  VALUE SPACE.
         03 FILLER            PIC X(3)  VALUE "END".
         03 FILLER            PIC X(2)  VALUE ALL SPACE.
         03 FILLER            PIC X(3)  VALUE "***".
      * 入出力件数メッセージ
       01  RECORD-COUNT-MSG-1.
         03 FILLER            PIC X(12)
                              VALUE "OUT-ITEM    ".
         03 FILLER            PIC X(10)
                              VALUE "  RECORD  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
       01  RECORD-COUNT-MSG-2.
         03 FILLER            PIC X(12)
                              VALUE "OUT-CATEGORY".
         03 FILLER            PIC X(10)
                              VALUE "  RECORD  ".
         03 FILLER            PIC X(10)
                              VALUE "  COUNT = ".
      * 件表示
       01  KEN                PIC X(3)
                              VALUE "件".
       01  CNS-MESSAGE.
         03 MESSAGE1          PIC X(13) VALUE "EXISTING-FILE".
         03 MESSAGE2          PIC X(13) VALUE "FILE-OPEN-ERR".
         03 MESSAGE3          PIC X(14) VALUE "FILE-CLOSE-ERR".
       PROCEDURE              DIVISION.
      ************************************************
      * メイン
      ************************************************
       MAIN                   SECTION.
       MAIN-000.
      *
           PERFORM INIT-PROC.
      *
           PERFORM ITEM-DATA-CRE-PROC.
           PERFORM CATEGORY-DATA-CRE-PROC.
      *
           PERFORM END-PROC.
      *
           STOP RUN.
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
           MOVE "OPEN"   TO    WK-FL-IO-KBN.
           OPEN INPUT OUT-ITEM-FILE OUT-CATEGORY-FILE.
           IF OUT-ITEM-SATAUS = "00"
             THEN
               DISPLAY MESSAGE1            UPON SYSOUT
               STOP RUN
             ELSE
               CONTINUE
           END-IF.
      *
           IF OUT-CATEGORY-SATAUS = "00"
             THEN
               DISPLAY MESSAGE1            UPON SYSOUT
               STOP RUN
             ELSE
               CONTINUE
           END-IF.
      *
           OPEN OUTPUT OUT-ITEM-FILE OUT-CATEGORY-FILE.
           IF OUT-ITEM-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE2            UPON SYSOUT
               STOP RUN
           END-IF.
      *
           IF OUT-CATEGORY-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE2            UPON SYSOUT
               STOP RUN
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
      * 件数表示
           DISPLAY RECORD-COUNT-MSG-1
             OUT-ITEM-COUNT KEN           UPON SYSOUT.
           DISPLAY RECORD-COUNT-MSG-2
             OUT-CATEGORY-COUNT KEN       UPON SYSOUT.    
      *
           MOVE "CLOSE"   TO    WK-FL-IO-KBN.
           CLOSE OUT-ITEM-FILE OUT-CATEGORY-FILE.
           IF OUT-ITEM-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE3            UPON SYSOUT
               STOP RUN
           END-IF.
           IF OUT-CATEGORY-SATAUS = "00"
             THEN
               CONTINUE
             ELSE
               DISPLAY MESSAGE3            UPON SYSOUT
               STOP RUN
           END-IF.
      *
      * 物品管理モジュールを呼び出す。
           CALL "DBGOODS01".
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
           INITIALIZE OUT-ITEM
                      OUT-CATEGORY
                      STTS
                      CNT
                      WK-FL-IO-KBN.
      *
       SYOKIKA-PROC-999.
           EXIT.
      *
      ************************************************
      * ITEMデータ作成処理
      ************************************************
       ITEM-DATA-CRE-PROC            SECTION.
       ITEM-DATA-CRE-PROC-000.
      *
           MOVE "0001"       TO OUT-ITEM-ID.
           MOVE "DESK"       TO OUT-ITEM-NAME.
           MOVE 10           TO OUT-ITEM-QUANTITY.
           MOVE 10000        TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0001"       TO OUT-ITEM-ID.
           MOVE "DESK"       TO OUT-ITEM-NAME.
           MOVE 20           TO OUT-ITEM-QUANTITY.
           MOVE 20000        TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0002"       TO OUT-ITEM-ID.
           MOVE "CHAIR"      TO OUT-ITEM-NAME.
           MOVE 30           TO OUT-ITEM-QUANTITY.
           MOVE 50000        TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0002"       TO OUT-ITEM-ID.
           MOVE "CHAIR"      TO OUT-ITEM-NAME.
           MOVE 20           TO OUT-ITEM-QUANTITY.
           MOVE 33333        TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0003"       TO OUT-ITEM-ID.
           MOVE "LOCKER"     TO OUT-ITEM-NAME.
           MOVE 2            TO OUT-ITEM-QUANTITY.
           MOVE 100000       TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0003"       TO OUT-ITEM-ID.
           MOVE "LOCKER"     TO OUT-ITEM-NAME.
           MOVE 4            TO OUT-ITEM-QUANTITY.
           MOVE 200000       TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0004"       TO OUT-ITEM-ID.
           MOVE "BROOM"      TO OUT-ITEM-NAME.
           MOVE 10           TO OUT-ITEM-QUANTITY.
           MOVE 50000        TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0004"       TO OUT-ITEM-ID.
           MOVE "BROOM"      TO OUT-ITEM-NAME.
           MOVE 20           TO OUT-ITEM-QUANTITY.
           MOVE 100000       TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
           MOVE "0005"       TO OUT-ITEM-ID.
           MOVE "PEN"        TO OUT-ITEM-NAME.
           MOVE 2            TO OUT-ITEM-QUANTITY.
           MOVE 1000         TO OUT-ITEM-PRICE.
           PERFORM ITEM-DATA-WRITE-PROC.
      *
       ITEM-DATA-CRE-PROC-999.
           EXIT.
      *
      ************************************************
      * CATEGORYデータ作成処理
      ************************************************
       CATEGORY-DATA-CRE-PROC            SECTION.
       CATEGORY-DATA-CRE-PROC-000.
      *
           MOVE "0001"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A001"     TO OUT-CATEGORY-ID.
           MOVE "EQUAIPMENT"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0001"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A001"     TO OUT-CATEGORY-ID.
           MOVE "EQUAIPMENT"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0002"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A001"     TO OUT-CATEGORY-ID.
           MOVE "EQUAIPMENT"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0002"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A001"     TO OUT-CATEGORY-ID.
           MOVE "EQUAIPMENT"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0003"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A001"     TO OUT-CATEGORY-ID.
           MOVE "EQUAIPMENT"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0003"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A001"     TO OUT-CATEGORY-ID.
           MOVE "EQUAIPMENT"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0004"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A002"     TO OUT-CATEGORY-ID.
           MOVE "SANITARY PRODUCTS"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0004"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A002"     TO OUT-CATEGORY-ID.
           MOVE "SANITARY PRODUCTS"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
           MOVE "0005"     TO OUT-CATEGORY-ITEM-ID.
           MOVE "A003"     TO OUT-CATEGORY-ID.
           MOVE "CONSUMABLE"
                           TO OUT-CATEGORY-NAME.
           PERFORM CATEGORY-DATA-WRITE-PROC.
      *
       CATEGORY-DATA-CRE-PROC-999.
           EXIT.
      *
      ************************************************
      * ITEMデータWRITE処理
      ************************************************
       ITEM-DATA-WRITE-PROC            SECTION.
       ITEM-DATA-WRITE-PROC-000.
      *
           MOVE "WRITE" TO WK-FL-IO-KBN.
      *
           WRITE OUT-ITEM
           END-WRITE.
      *
           COMPUTE OUT-ITEM-COUNT = OUT-ITEM-COUNT + 1.
      *
       ITEM-DATA-WRITE-PROC-999.
           EXIT.
      *
      ************************************************
      * CATEGORYデータWRITE処理
      ************************************************
       CATEGORY-DATA-WRITE-PROC            SECTION.
       CATEGORY-DATA-WRITE-PROC-000.
      *
           MOVE "WRITE" TO WK-FL-IO-KBN.
      *
           WRITE OUT-CATEGORY
           END-WRITE.
      *
           COMPUTE OUT-CATEGORY-COUNT = OUT-CATEGORY-COUNT + 1.
      *
       CATEGORY-DATA-WRITE-PROC-999.
           EXIT.
      *

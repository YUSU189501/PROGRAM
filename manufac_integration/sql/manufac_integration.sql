CREATE OR REPLACE PROCEDURE manufac_integration()
AS $$
  DECLARE
    
    /* コミット件数 */
    C_LIMIT NUMERIC := 1;
    
    /* FETCH用カウンタ初期化 */
    FET_CNT INTEGER := 0;
    
    /* 経過用カウンタ初期化 */
    PROGRESS_CNT INTEGER := 0;
    
    /* 自動車メーカー統合テーブル初期化 */
    MANUFAC_INS_CNT_BF INTEGER := 0;
    MANUFAC_INS_CNT    INTEGER := 0;
    
    /* 処理TBL名 */
    SYORI_TABLE VARCHAR(40);
    
    /* 処理TBL
    TOYOTA_CARS      トヨタテーブル
    NISSAN_CARS      日産テーブル
    HONDA_CARS       ホンダテーブル
    MAZDA_CARS       マツダテーブル
    DAIHATSU_CARS    ダイハツテーブル
    SUBARU_CARS      スバルテーブル
    MITSUBISHI_CARS  三菱テーブル
    MANUFAC_KNR      メーカー管理テーブル
    */
    
    -- 自動車メーカー統合テーブル前段カーソル処理
    MANUF_CURSOR CURSOR FOR
    SELECT K.MANUFAC_NAME,
           M.CAR_ID,
           M.VINUBER,
           M.MODEL_NAME,
           M.YEAR,
           M.COLOR,
           M.ENGINE_TYPE,
           M.MILEAGE,
           M.STATUS,
           M.PRICE
    FROM
     (
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   TOYOTA_CARS
      UNION ALL
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   NISSAN_CARS
      UNION ALL
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   HONDA_CARS
      UNION ALL
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   MAZDA_CARS
      UNION ALL
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   DAIHATSU_CARS
      UNION ALL
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   SUBARU_CARS
      UNION ALL
      SELECT MANUFAC_ID,
             CAR_ID,
             VINUBER,
             MODEL_NAME,
             YEAR,
             COLOR,
             ENGINE_TYPE,
             MILEAGE,
             STATUS,
             PRICE
      FROM   MITSUBISHI_CARS
     ) M
    JOIN MANUFAC_KNR K
    ON M.MANUFAC_ID = K.MANUFAC_ID
    ORDER BY M.MANUFAC_ID, M.CAR_ID;
    
  BEGIN
    FOR MANUF_REC IN MANUF_CURSOR LOOP
      /* FETCH用カウンタ */
      FET_CNT := FET_CNT + 1;
      
      BEGIN
        
        SYORI_TABLE='MANUFAC_INTEGRATION';
        
        INSERT INTO MANUFAC_INTEGRATION
        (
         MANUFAC_NAME,
         CAR_ID,
         VINUBER,
         MODEL_NAME,
         YEAR,
         COLOR,
         ENGINE_TYPE,
         MILEAGE,
         STATUS,
         PRICE,
         UPDATE_DATE,
         UPDATE_CNT,
         RNR_DEL_FLG
        )
        VALUES
        (
         MANUF_REC.MANUFAC_NAME,
         MANUF_REC.CAR_ID,
         MANUF_REC.VINUBER,
         MANUF_REC.MODEL_NAME,
         MANUF_REC.YEAR,
         MANUF_REC.COLOR,
         MANUF_REC.ENGINE_TYPE,
         MANUF_REC.MILEAGE,
         MANUF_REC.STATUS,
         MANUF_REC.PRICE,
         CURRENT_DATE,
         '1',
         '0'
        );
        
        GET DIAGNOSTICS MANUFAC_INS_CNT_BF = ROW_COUNT;
        MANUFAC_INS_CNT := MANUFAC_INS_CNT + MANUFAC_INS_CNT_BF;
        
        IF FET_CNT = C_LIMIT
        THEN
          /* コミットしない */
          FET_CNT := 0;
          MANUFAC_INS_CNT_BF := 0;
        ELSE
          NULL;
        END IF;
      EXCEPTION
        WHEN OTHERS
        THEN
          RAISE NOTICE '処理TBL=% SQLSTATE=% エラーメッセージ=%', SYORI_TABLE, SQLSTATE, SQLERRM;
      END;
    END LOOP;
    
    COMMIT;
    
    /* 追加カウンタ 総件数確定 */
    MANUFAC_INS_CNT := MANUFAC_INS_CNT + MANUFAC_INS_CNT_BF;
    
    /* 経過ログ */
    RAISE NOTICE 'MANUFAC_INTEGRATION(自動車メーカー統合テーブル)追加件数%', MANUFAC_INS_CNT;
    
  END;
$$ LANGUAGE plpgsql;

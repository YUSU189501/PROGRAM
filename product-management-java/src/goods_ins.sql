CREATE OR REPLACE PROCEDURE goods_ins()
AS $$
  DECLARE
    
    /* コミット件数 */
    C_LIMIT NUMERIC := 1;
    
    /* FETCH用カウンタ初期化 */
    FET_CNT INTEGER := 0;
    
    /* 経過用カウンタ初期化 */
    PROGRESS_CNT INTEGER := 0;
    
    /* 物品管理テーブル初期化 */
    GOODS_INS_CNT_BF   INTEGER := 0;
    GOODS_INS_CNT      INTEGER := 0;
    
    /* 物品管理連番初期化 */
    V_MAX_RENBN INTEGER :=0;
    V_RENBN     INTEGER :=0;
    
    /* 処理TBL名 */
    SYORI_TABLE VARCHAR(40);
    
    /* 処理TBL
    ITEM             商品テーブル
    CATEGORY         カテゴリテーブル
    */
    
    -- 物品管理結合カーソル処理
    GOODS_CURSOR CURSOR FOR
    SELECT
      I.ITEM_ID,
      I.ITEM_NAME,
      C.CATEGORY_ID,
      C.CATEGORY_NAME,
      COALESCE(SUM(I.QUANTITY), 0) AS QUANTITY,
      COALESCE(SUM(I.PRICE), 0) AS PRICE
    FROM
      ITEM I
    JOIN CATEGORY C
    ON   I.ITEM_ID = C.ITEM_ID
    AND  I.ITEM_RENBN = C.CATEGORY_RENBN
    GROUP BY
      I.ITEM_ID,
      I.ITEM_NAME,
      C.CATEGORY_ID,
      C.CATEGORY_NAME
    ORDER BY
      I.ITEM_ID,
      C.CATEGORY_ID;
    
  BEGIN
    FOR GOODS_REC IN GOODS_CURSOR LOOP
      /* FETCH用カウンタ */
      FET_CNT := FET_CNT + 1;
      
      BEGIN
        
        SYORI_TABLE := 'GOODS';
        
        -- item_id ごとの最大 renbn を取得して +1 採番
        SELECT COALESCE(MAX(GOODS_RENBN), 0)
        INTO V_MAX_RENBN
        FROM GOODS
        WHERE ITEM_ID = GOODS_REC.ITEM_ID;
        
        IF V_MAX_RENBN < 99999 THEN
          V_RENBN := V_MAX_RENBN + 1;
        ELSE
          RAISE EXCEPTION 'GOODS_RENBN overflow for ITEM_ID=%', GOODS_REC.ITEM_ID;
        END IF;
        
        SYORI_TABLE := 'GOODS';
        
        INSERT INTO GOODS
        (
         ITEM_ID,
         GOODS_RENBN,
         ITEM_NAME,
         CATEGORY_ID,
         CATEGORY_NAME,
         QUANTITY,
         PRICE,
         UPDATE_DATE
        )
        VALUES
        (
         GOODS_REC.ITEM_ID,
         V_RENBN,
         GOODS_REC.ITEM_NAME,
         GOODS_REC.CATEGORY_ID,
         GOODS_REC.CATEGORY_NAME,
         GOODS_REC.QUANTITY,
         GOODS_REC.PRICE,
         CURRENT_TIMESTAMP
        );
        
        GET DIAGNOSTICS GOODS_INS_CNT_BF = ROW_COUNT;
        GOODS_INS_CNT := GOODS_INS_CNT + GOODS_INS_CNT_BF;
        
        IF FET_CNT = C_LIMIT
        THEN
          /* コミットしない */
          FET_CNT := 0;
          GOODS_INS_CNT_BF := 0;
        ELSE
          NULL;
        END IF;
      EXCEPTION
        WHEN OTHERS
        THEN
          RAISE NOTICE '処理TBL=% SQLSTATE=% エラーメッセージ=%', SYORI_TABLE, SQLSTATE, SQLERRM;
      END;
    END LOOP;
    
    /* 追加カウンタ 総件数確定 */
    GOODS_INS_CNT := GOODS_INS_CNT + GOODS_INS_CNT_BF;
    
    /* 経過ログ */
    RAISE NOTICE 'GOODS(物品管理テーブル) 追加件数=%件', GOODS_INS_CNT;
    
  END;
$$ LANGUAGE plpgsql;

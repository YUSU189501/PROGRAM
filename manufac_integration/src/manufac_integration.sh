#!/bin/bash
#----------------------------------------------
# １.ファイル名 manufac_integration.sh
#
# ２.処理名：自動車メーカー統合テーブル登録処理起動シェル
#
# ３.処理概要：自動車メーカー統合テーブル登録処理を
#              ストアドプロシージャで処理をする。
#
# ４.作成者：鈴木 裕大
#
# ５.作成日：2025/02/22
#
# ６.引数  なし
#-----------------------------------------------
# プロパティファイル参照
source ./manufac_integration.propeties

# 環境変数設定
export LANG=ja_JP.UTF8

# リターンコードの初期化
RC=0

# SQLの実行
export PGPASSWORD=${DB_PASSWD}
psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d  ${DB_NAME} -f ${SQL_FILE}

# リターンコードの設定
RC=$?

if [ ${RC} -eq 0 ]; then
	echo "SQLファイルが正常に実行されました。"
	psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "CALL manufac_integration();"
	psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "SELECT * FROM MANUFAC_INTEGRATION;"
else
	echo "SQLファイルの実行に失敗しました。"
fi

exit ${RC}

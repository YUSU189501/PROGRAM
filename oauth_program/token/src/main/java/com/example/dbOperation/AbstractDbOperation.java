package com.example.dbOperation;

import java.io.*;
import java.sql.*;
import java.util.*;

/**
 * データベース操作のための抽象クラスです。
 * <p>
 * 共通のDB接続処理を提供し、実際の処理はサブクラスで実装します。
 * </p>
 */
public abstract class AbstractDbOperation {
	/**
     * PostgreSQLデータベースへの接続を取得します。
     * <p>
     * プロパティファイル（dbOperation/SQL.properties）から接続情報を読み込みます。
     * </p>
     *
     * @return データベースへの接続オブジェクト
     * @throws SQLException SQLエラーが発生した場合
     * @throws IOException プロパティファイルの読み込みに失敗した場合
     * @throws ClassNotFoundException JDBCドライバが見つからない場合
     */
	protected Connection getConnection() throws SQLException, IOException, ClassNotFoundException {
    	try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("ドライバのロードに失敗しました", e);
        }
    	 ResourceBundle rb = ResourceBundle.getBundle("com.example.dbOperation.SQL");
        String url = rb.getString("sqlurl");
        String user = rb.getString("sqluser");
        String password = rb.getString("sqlpassword");
        return DriverManager.getConnection(url, user, password);
    }
	protected void close(Connection conn) {
        try {
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

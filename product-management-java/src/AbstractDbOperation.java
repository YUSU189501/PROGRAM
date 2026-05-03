package goods.management;

import java.io.*;
import java.sql.*;
import java.util.*;

public abstract class AbstractDbOperation {
	// プロパティファイルの読み込み
	protected Properties loadSqlProperties() throws IOException {
        try (Reader fr = new FileReader("/home/suzuki/eclipse-workspace/SQLPersonal/SQL.properties")) {
            Properties p = new Properties();
            p.load(fr);
            return p;
        }
    }

	// JDBCドライバのロード
	protected Connection getConnection() throws SQLException, IOException, ClassNotFoundException {
    	try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("ドライバのロードに失敗しました", e);
        }
        Properties prop = loadSqlProperties();
        String url = prop.getProperty("sqlurl");
        String user = prop.getProperty("sqluser");
        String password = prop.getProperty("sqlpassword");
        return DriverManager.getConnection(url, user, password);
    }

    // 接続以降をサブクラスで実装
    public abstract void execute();
}

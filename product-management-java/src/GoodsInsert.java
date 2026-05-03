package goods.management;

import java.sql.*;
import java.io.*;
import java.util.*;

class GoodsInsert extends AbstractDbOperation {
	@Override
    public void execute() {
    	System.out.println("***  GoodsInsert START  ***");
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            // ストアドプロシジャーを呼び出す。
            String sql = "CALL goods_ins()";
            try (CallableStatement stmt = con.prepareCall(sql)) {
            	stmt.execute();
            	
            	// PostgreSQLのNOTICEメッセージを取得
                SQLWarning warning = stmt.getWarnings();
                while (warning != null) {
                    System.out.println("NOTICE: " + warning.getMessage());
                    warning = warning.getNextWarning();
                }
            	
            	System.out.println("ストアドプロシージャが実行されました。");
            }
            con.commit();
            
            System.out.println("***  GoodsInsert END    ***");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

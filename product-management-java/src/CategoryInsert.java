package goods.management;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

class CategoryInsert extends AbstractDbOperation {
	@Override
	// CATEGORYFILE.txt→CATEGORYテーブルへINSERT
	public void execute() {
        System.out.println("***  CategoryInsert START  ***");
        
        String filePath = "/home/suzuki/eclipse-workspace/SQLPersonal/CATEGORYFILE.txt";
        
        int readCount = 0;
        int insertCount = 0;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            List<String> lines = Files.readAllLines(Paths.get(filePath));
            readCount = lines.size();

            for (String line : lines) {
                String itemId = line.substring(0, 4);
                String categoryId = line.substring(4, 8);
                String categoryName = line.substring(8).trim();

                int nextRenbn = getNextRenbn(con, itemId);

                insertCategory(con, itemId, nextRenbn, categoryId, categoryName);
                insertCount++;
            }

            con.commit();

            System.out.printf("IN-CATEGORY   RECORD    COUNT = %d件%n", readCount);
            System.out.printf("CATEGORY      INSERT    COUNT = %d件%n", insertCount);
            System.out.println("***  CategoryInsert END  ***");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // カテゴリ連番の設定
    private static int getNextRenbn(Connection con, String itemId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(category_renbn), 0) FROM category WHERE item_id = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, itemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1;
        }
    }

    // CATEGORYテーブルへのINSERT
    private static void insertCategory(Connection con, String itemId, int renbn,
                                       String categoryId, String categoryName) throws SQLException {
        String sql = "INSERT INTO category (item_id, category_renbn, category_id, category_name, update_date) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, itemId);
            stmt.setInt(2, renbn);
            stmt.setString(3, categoryId);
            stmt.setString(4, categoryName);
            stmt.setTimestamp(5, new Timestamp(new Date().getTime()));
            stmt.executeUpdate();
        }
    }
}
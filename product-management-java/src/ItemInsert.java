package goods.management;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

class ItemInsert extends AbstractDbOperation {
	@Override
	// ITEMFILE.txt→ITEMテーブルへINSERT
	public void execute() {
        System.out.println("***  ItemInsert START  ***");

        String filePath = "/home/suzuki/eclipse-workspace/SQLPersonal/ITEMFILE.txt";

        int readCount = 0;
        int insertCount = 0;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            List<String> lines = Files.readAllLines(Paths.get(filePath));
            readCount = lines.size();

            for (String line : lines) {
                String itemId = line.substring(0, 4);
                String itemName = line.substring(4, 34).trim();
                int quantity = Integer.parseInt(line.substring(34, 38));
                long price = Long.parseLong(line.substring(38, 47));

                int nextRenbn = getNextRenbn(con, itemId);

                insertItem(con, itemId, nextRenbn, itemName, quantity, price);
                insertCount++;
            }

            con.commit();

            System.out.printf("IN-ITEM      RECORD    COUNT = %d件%n", readCount);
            System.out.printf("ITEM         INSERT    COUNT = %d件%n", insertCount);
            System.out.println("***  ItemInsert END  ***");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 商品連番の設定
    private static int getNextRenbn(Connection con, String itemId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(item_renbn), 0) FROM item WHERE item_id = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, itemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1;
        }
    }

    // ITEMテーブルへのINSERT
    private static void insertItem(Connection con, String itemId, int renbn,
                                   String name, int qty, long price) throws SQLException {
        String sql = "INSERT INTO item (item_id, item_renbn, item_name, quantity, price, update_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, itemId);
            stmt.setInt(2, renbn);
            stmt.setString(3, name);
            stmt.setInt(4, qty);
            stmt.setLong(5, price);
            stmt.setTimestamp(6, new Timestamp(new Date().getTime()));

            stmt.executeUpdate();
        }
    }
}
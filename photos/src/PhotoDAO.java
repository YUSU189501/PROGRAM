package photo.blob;

import java.sql.*;
import java.io.*;

class PhotoDAO extends AbstractDbOperation {
	private int insCount;
	private int writeCount;
	
	public int getinsCount() {
		return insCount;
	}
	
	public int getwriteCount() {
		return writeCount;
	}
	
	public void insertPhoto(String filename, byte[] data, Timestamp updatedAt) {
		try (Connection con = getConnection()) {	
			con.setAutoCommit(false);
			String sql = "INSERT INTO photos (filename, data, update_at) VALUES (?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, filename);
			ps.setBytes(2, data);
			ps.setTimestamp(3, updatedAt);
			ps.executeUpdate();
			insCount++;
			con.commit();
        } catch (Exception e) {
           e.printStackTrace();
        }
	}
	// 複数画像取得用メソッド
	public void getAllPhotos() {
		// photo_resultを定義
		String outputDirPath = "/home/suzuki/eclipse-workspace/SQLPersonal/photo_result";
		File outputDir = new File(outputDirPath);
		// ディレクトリがなければ作成
		if (!outputDir.exists())
			outputDir.mkdir();
		
		try (Connection con = getConnection()) {	
			con.setAutoCommit(false);
			String sql = "SELECT filename, data FROM photos";
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				String fileName = rs.getString("filename");
				InputStream input = rs.getBinaryStream("data");
				
				File outFile = new File(outputDir, fileName);
				try (FileOutputStream output = new FileOutputStream(outFile)) {
					byte[] buffer = new byte[4096];
					int bytesRead;
					while ((bytesRead = input.read(buffer)) != -1) {
						output.write(buffer, 0 ,bytesRead);
					}
				}
				input.close();
				writeCount++;
			}
			con.commit();
        } catch (Exception e) {
           e.printStackTrace();
        }
	}
}
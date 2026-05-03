package photo.blob;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.Date;

public class PhotoApp {
	public static void main(String[] args) {
		System.out.println("*** PhotoApp START ***");
		String dir = "/home/suzuki/eclipse-workspace/SQLPersonal/photos";
		PhotoDAO dao = new PhotoDAO();
		try {
			// 写真ファイルをDBに登録
			File folder = new File(dir);
			File[] files = folder.listFiles();
			if (files != null) {
				for (File file : files) {
					String filename = file.getName();
					byte[] data = Files.readAllBytes(file.toPath());
					Timestamp updatedAt = new Timestamp(new Date().getTime());	
					dao.insertPhoto(filename, data, updatedAt);
				}
				dao.getAllPhotos();
			}
			System.out.println("photos 追加件数" + dao.getinsCount() + "件");
			System.out.println("photo_result 出力件数" + dao.getwriteCount() + "件");
			System.out.println("*** PhotoApp END ***");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

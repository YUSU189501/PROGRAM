package com.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import com.example.dbOperation.AbstractDbOperation;

public class TokenDAO extends AbstractDbOperation {
	public String findAuthCodeByClientIdVulnerable(String clientId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String code = null;
		
		try {
			conn = getConnection();
			
			//  脆弱なSQLの解消版（論文用）
			String sql = "SELECT code FROM auth_codes WHERE client_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, clientId);
          System.out.println("DEBUG SQL: " + sql);

          rs = pstmt.executeQuery();

          if (rs.next()) {  
        	  code = rs.getString("code");
            }
		} catch (Exception e) {
            e.printStackTrace();
        } finally {
        	 try { if (rs != null) rs.close(); } catch (Exception ignored) {}
           try { if (pstmt != null) pstmt.close(); } catch (Exception ignored) {}
           close(conn);
        }
       return code;
	}
}

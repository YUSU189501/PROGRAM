package com.example.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.example.dbOperation.AbstractDbOperation;

public class TokenDAO extends AbstractDbOperation {
	public String findAuthCodeByClientIdVulnerable(String clientId) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		String code = null;
		
		try {
			conn = getConnection();
			
			//  入力値をそのまま連結（脆弱）
			String sql = "SELECT code FROM auth_codes WHERE client_id = '" + clientId + "'";
		   System.out.println("DEBUG SQL (VULN): " + sql);

		   stmt = conn.createStatement();
		   rs = stmt.executeQuery(sql);
		        
          if (rs.next()) {  
        	  code = rs.getString("code");
            }
		} catch (Exception e) {
            e.printStackTrace();
        } finally {
        	 try { if (rs != null) rs.close(); } catch (Exception ignored) {}
           try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
           close(conn);
        }
       return code;
	}
}

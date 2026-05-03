package com.example.token;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import com.example.model.AuthCodes;
import com.example.model.TokenLogic;
/**
 * Servlet implementation class Token
 */
@WebServlet("/Token")
public class Token extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Token() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// パラメータ取得
        String clientId = request.getParameter("client_id");

        // ログ出力（検証用）
        System.out.println("client_id: " + clientId);

        // ロジック呼び出し
     // DTO生成
        AuthCodes authCodes = new AuthCodes(
                null,
                clientId,
                new Timestamp(System.currentTimeMillis())
        );

        TokenLogic logic = new TokenLogic();
        String code = logic.execute(authCodes);

        // レスポンス
        response.setContentType("text/html; charset=UTF-8");

        if (code != null) {
            response.getWriter().println("<h2>取得された認可コード: " + code + "</h2>");
        } else {
            response.getWriter().println("<h2>認可コードが見つかりません</h2>");
        }
	}
}

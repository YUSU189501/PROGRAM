package com.example.oauth;

import java.io.IOException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/authorize")
public class AuthorizeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 脆弱性ありの認可エンドポイント。
     *
     * 脆弱点：
     * 1. redirect_uriを検証していない
     * 2. stateを使用していない
     * 3. ログイン済み確認をせず、強制的にログイン扱いにしている
     * 4. 攻撃者のcallbackにも認可コードを送信してしまう
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String clientId = request.getParameter("client_id");
        String redirectUri = request.getParameter("redirect_uri");
        String responseType = request.getParameter("response_type");

        System.out.println("clientId = " + clientId);
        System.out.println("redirectUri = " + redirectUri);
        System.out.println("responseType = " + responseType);

        if (!"code".equals(responseType)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid response_type");
            return;
        }

        // 脆弱：ログイン確認せず、ログイン済みとして扱う
        HttpSession session = request.getSession();
        session.setAttribute("loginUser", "user001");

        // 認可コード発行
        String authCode = UUID.randomUUID().toString();

        session.setAttribute("authCode", authCode);
        session.setAttribute("clientId", clientId);

        // 脆弱：redirect_uriを検証せず、そのままリダイレクト
        response.sendRedirect(redirectUri + "?code=" + authCode);
    }
}
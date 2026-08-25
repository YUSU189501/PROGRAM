package com.example.oauth;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * OAuth 2.0 の認可エンドポイントを模した安全版API。
 * 
 * 対策内容：
 * 1. response_type の検証
 * 2. client_id の検証
 * 3. redirect_uri の完全一致検証
 * 4. state パラメータ必須化
 * 5. ログイン済みセッション確認
 * 6. 認可コードとstateのURLエンコード
 */
@WebServlet("/authorize")
public class AuthorizeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 本来はDBで管理するクライアント情報。
     * 
     * key   : client_id
     * value : 登録済み redirect_uri
     */
    private static final Map<String, String> REGISTERED_CLIENTS = Map.of(
        "client-app-001", "http://localhost:8080/client/callback"
    );

    @Override
    public void init() throws ServletException {
        System.out.println("### AuthorizeServlet 安全版 INIT ###");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // リクエストパラメータ取得
        String clientId = request.getParameter("client_id");
        String redirectUri = request.getParameter("redirect_uri");
        String responseType = request.getParameter("response_type");
        String state = request.getParameter("state");

        // デバッグログ
        System.out.println("requestURL   = " + request.getRequestURL());
        System.out.println("queryString  = " + request.getQueryString());
        System.out.println("clientId     = " + clientId);
        System.out.println("redirectUri  = " + redirectUri);
        System.out.println("responseType = " + responseType);
        System.out.println("state        = " + state);

        // response_type は code のみ許可
        if (!"code".equals(responseType)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid response_type");
            return;
        }

        // client_id が登録済みか確認
        if (clientId == null || !REGISTERED_CLIENTS.containsKey(clientId)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid client_id");
            return;
        }

        // 登録済み redirect_uri を取得
        String registeredRedirectUri = REGISTERED_CLIENTS.get(clientId);

        // redirect_uri は完全一致で検証する
        // 攻撃者の callback URL への認可コード漏えいを防ぐ
        if (redirectUri == null || !registeredRedirectUri.equals(redirectUri)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid redirect_uri");
            return;
        }

        // state はCSRF対策として必須
        if (state == null || state.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "state is required");
            return;
        }

        // 既存セッションのみ取得する
        // getSession() にすると未ログインでも新規セッションが作られてしまう
        HttpSession session = request.getSession(false);

        // ログイン済みか確認
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "login required");
            return;
        }

        // 認可コードを発行
        String authCode = UUID.randomUUID().toString();

        // セッションに認可情報を保存
        session.setAttribute("authCode", authCode);
        session.setAttribute("clientId", clientId);
        session.setAttribute("state", state);

        // URLに付与する値はエンコードする
        String encodedCode = URLEncoder.encode(authCode, StandardCharsets.UTF_8);
        String encodedState = URLEncoder.encode(state, StandardCharsets.UTF_8);

        // 登録済み redirect_uri にのみリダイレクトする
        response.sendRedirect(
            redirectUri + "?code=" + encodedCode + "&state=" + encodedState
        );
    }
}
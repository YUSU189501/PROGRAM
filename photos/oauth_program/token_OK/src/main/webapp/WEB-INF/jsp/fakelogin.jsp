<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>偽認証画面</title>
<style>
    body {
      font-family: sans-serif;
      background: #f5f5f5;
      padding: 40px;
    }

    .login-box {
      width: 360px;
      margin: 0 auto;
      background: white;
      padding: 24px;
      border-radius: 8px;
      box-shadow: 0 0 8px rgba(0,0,0,0.15);
    }

    h1 {
      font-size: 20px;
      text-align: center;
    }

    label {
      display: block;
      margin-top: 16px;
    }

    input {
      width: 100%;
      padding: 8px;
      margin-top: 4px;
      box-sizing: border-box;
    }

    button {
      width: 100%;
      margin-top: 24px;
      padding: 10px;
      background: #1976d2;
      color: white;
      border: none;
      cursor: pointer;
    }

    .note {
      margin-top: 16px;
      font-size: 12px;
      color: #666;
    }
  </style>
</head>
<body>
<div class="login-box">
    <h1>OAuth 認証確認</h1>

    <form action="Token" method="get">
      <label for="client_id">client_id</label>
      <input type="text" id="client_id" name="client_id">

      <button type="submit">認証する</button>
    </form>

    <div class="note">
      ※ 論文検証用の偽認証画面です。
    </div>
  </div>

</body>
</html>
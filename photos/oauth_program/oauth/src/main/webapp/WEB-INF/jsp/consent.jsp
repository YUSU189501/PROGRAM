<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OAuth同意画面</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
  background-color: #f7f7f7;
}
.container {
  margin-top: 100px;
}
.consent-box {
  max-width: 480px;
  margin: 0 auto;
  padding: 30px;
  background-color: white;
  box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
  border-radius: 10px;
}
.allow-btn {
  background-color: #4285F4;
  color: white;
}
</style>
</head>
<body>
<div class="container">
  <div class="consent-box">
    <h2 class="mb-4">OAuth 同意確認</h2>

    <p>このアプリが以下の情報へのアクセスを要求しています。</p>

    <ul>
      <li>ユーザー情報</li>
      <li>メールアドレス</li>
      <li>認可コードの発行</li>
    </ul>

    <p class="text-danger">
      ※ ローカル検証用の模擬OAuth同意画面です。
    </p>

    <form action="${pageContext.request.contextPath}/authorize" method="get">
      <input type="hidden" name="client_id" value="attacker-client">
      <input type="hidden" name="redirect_uri" value="http://localhost:8080/attacker/callback">
      <input type="hidden" name="response_type" value="code">

      <button type="submit" class="btn allow-btn">許可する</button>
    </form>
  </div>
</div>
</body>
</html>
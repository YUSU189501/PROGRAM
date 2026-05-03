/**
 * OAuth 認証確認を送信
 */
const form = document.getElementById("fakeLoginForm");

    form.addEventListener("submit", function(event) {
      const clientId = document.getElementById("client_id").value;

      console.log("送信する client_id:", clientId);

      // 検証用：空欄チェックだけ
      if (clientId.trim() === "") {
        alert("client_idを入力してください");
        event.preventDefault();
      }
    });
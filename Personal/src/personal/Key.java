package personal;

public class Key {
    // メンバ変数
    private char keyChar;
    private Key left;

    // コンストラクタ (1)
    public Key(char qChar) {
        this.keyChar = qChar;
        this.left = null; // leftは未定義
    }

    // コンストラクタ (2)
    public Key(char qChar, Key qLeft) {
        this.keyChar = qChar;
        this.left = qLeft;
    }

    // メソッド showKey
    public String showKey() {
        if (left == null) {
            return keyChar + "の左隣は未定義。";
        } else {
            return keyChar + "の左隣は" + left.keyChar + "。";
        }
    }
}
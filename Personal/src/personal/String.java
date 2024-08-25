package personal;

class String {
    private java.lang.String str;

    // コンストラクタ
    public String(java.lang.String s) {
        this.str = s;
    }

    // slice メソッド
    public String slice(int start, int end) {
        // start と end は 0 ベースで指定されるので、そのまま substring メソッドに渡す
        return new String(this.str.substring(start, end));
    }

    // concat メソッド
    public String concat(String a) {
        return new String(this.str + a.str);
    }

    // charAt メソッド
    public String charAt(int index) {
        // index は 0 ベースで指定されるので、そのまま charAt メソッドに渡す
        return new String(java.lang.String.valueOf(this.str.charAt(index)));
    }

    // メインメソッドでテスト
    public static void main(java.lang.String... args) {
        String s1 = new String("ABABA");
        String s2 = s1.slice(1, 3);
        String s3 = s2.concat(s1.charAt(3)).concat(s2);
        // 結果を出力
        System.out.println(s3.str);  // "BABBA"
    }
}
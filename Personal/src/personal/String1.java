package personal;

class String1 {
    private String str;

    // コンストラクタ
    public String1(String s) {
        this.str = s;
    }

    // slice メソッド
    public String1 slice(int start, int end) {
        // start と end は 0 ベースで指定されるので、そのまま substring メソッドに渡す
        return new String1(this.str.substring(start, end));
    }

    // concat メソッド
    public String1 concat(String1 a) {
        return new String1(this.str + a.str);
    }

    // charAt メソッド
    public String1 charAt(int index) {
        // index は 0 ベースで指定されるので、そのまま charAt メソッドに渡す
        return new String1(String.valueOf(this.str.charAt(index)));
    }

    // str フィールドのゲッターメソッド
    public String getStr() {
        return this.str;
    }

    // メインメソッドでテスト
    public static void main(String... args) {
        String1 s1 = new String1("ABABA");
        String1 s2 = s1.slice(1, 3);
        String1 s3 = s2.concat(s1.charAt(3)).concat(s2);
        // 結果を出力
        System.out.println(s3.getStr());  // "BABBA"
    }
}
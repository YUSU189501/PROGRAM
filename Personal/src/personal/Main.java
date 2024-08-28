package personal;

class Main {
    public static void main(String[] args) {
        // straightメソッドを呼び出し
        straight(new String[]{"A", "S", "D", "F"});
    }

    public static void straight(String[] keyArray) {
        Key[] keys = new Key[keyArray.length];

        // 最初のキーを初期化（左隣は未定義）
        keys[0] = new Key(keyArray[0].charAt(0));

        // 2番目以降のキーを初期化し、左隣を設定
        for (int i = 1; i < keyArray.length; i++) {
            keys[i] = new Key(keyArray[i].charAt(0), keys[i - 1]);
        }

        // showKeyメソッドを呼び出して結果を出力
        for (int i = 0; i < keys.length; i++) {
            System.out.println(keys[i].showKey());
        }
    }  
}
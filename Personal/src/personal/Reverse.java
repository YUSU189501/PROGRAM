package personal;

public class Reverse {
	public static void main(String[] args) {
		// 整数型の配列
		int[] array = {1, 2, 3, 4, 5};
		
		// 整数型の配列arrayの要素の並びを逆順にする。
		int right;
		int tmp;
		int n = array.length;
		
		for (int left = 0; left < n / 2; left++) {
			right = n - left - 1;
			tmp = array[right];
			array[right] = array[left];
			array[left] = tmp;
		}
		// 結果を表示
		System.out.print("逆順になった配列array:");
		for (int i :array) {
			System.out.print(i + " ");
		}
	}
}
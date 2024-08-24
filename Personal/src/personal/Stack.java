package personal;
import java.util.ArrayDeque;
import java.util.Deque;

public class Stack {
	public static void main(String[] args) {
		Deque <Integer> deque = new ArrayDeque<>();
		deque.push(1);
		deque.push(5);
		System.out.println("deque" + deque);
		System.out.println("Stack:" + deque.pop());
		System.out.println("deque" + deque);
		deque.push(7);
		deque.push(6);
		System.out.println("deque" + deque);
		System.out.println("Stack:" + deque.pop());
		System.out.println("Stack:" + deque.pop());
		deque.push(3);
		System.out.println("deque" + deque);
	}
}
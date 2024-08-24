package personal;
import java.util.ArrayDeque;
import java.util.Queue;

public class Queues {
	public static void main(String args[]) {
		Queue<Integer> queue = new ArrayDeque<>();
		
		// ENQ OPERATIONS
		queue.add(1);
		queue.add(2);
		queue.add(3);
		System.out.println("ENQ:" + queue);
		
		// DEQ OPERATIONS
		System.out.println("DEQ:" + queue.poll());
		
		// ENQ OPERATIONS
		queue.add(4);
		queue.add(5);
		System.out.println("ENQ:" + queue);
		
		// DEQ OPERATIONS
		System.out.println("DEQ:" + queue.poll());
				
		// ENQ OPERATIONS
		queue.add(6);
		System.out.println("ENQ:" + queue);
		
		// DEQ OPERATIONS
		System.out.println("DEQ:" + queue.poll());
		
		
		// DEQ OPERATIONS
		System.out.println("DEQ:" + queue.poll());
	}
}
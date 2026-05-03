package goods.management;

public class Main {
	public static void main(String[] args) {
		AbstractDbOperation i = new ItemInsert();
		AbstractDbOperation c = new CategoryInsert();
		AbstractDbOperation g = new GoodsInsert();
		i.execute();
		c.execute();
		g.execute();
	}
}

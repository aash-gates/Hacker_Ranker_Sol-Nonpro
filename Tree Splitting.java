import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.InputMismatchException;

public class E2 {
	InputStream is;
	PrintWriter out;
	String INPUT = "";

	void solve()
	{
		int n = ni();
		int[] from = new int[n - 1];
		int[] to = new int[n - 1];
		Node[] nodes = new Node[n];
		for(int i = 0;i < n;i++){
			nodes[i] = new Node(i);
		}
		for (int i = 0; i < n - 1; i++) {
			from[i] = ni() - 1;
			to[i] = ni() - 1;
		}
		int[][] g = packU(n, from, to);
		int[][] pars = parents3(g, 0);
		int[] par = pars[0];
		for(int i = 0;i < n;i++){
			if(par[i] != -1){
				link(nodes[par[i]], nodes[i]);
			}
		}
		
		int ans = 0;
		boolean[] deled = new boolean[n];
		for(int Q = ni();Q > 0;Q--){
			int x = ni()^ans;
			x--;

			expose(nodes[x]);

			ans = nodes[x].size + nodes[x].sumexsize;

			out.println(ans);
			for(int e : g[x]){
				if(!deled[e]){
					if(par[x] == e){
						cut(nodes[x]);
					}else{
						cut(nodes[e]);
					}
				}
			}
			deled[x] = true;
		}
	}

	public static int[][] parents3(int[][] g, int root) {
		int n = g.length;
		int[] par = new int[n];
		Arrays.fill(par, -1);

		int[] depth = new int[n];
		depth[0] = 0;

		int[] q = new int[n];
		q[0] = root;
		for (int p = 0, r = 1; p < r; p++) {
			int cur = q[p];
			for (int nex : g[cur]) {
				if (par[cur] != nex) {
					q[r++] = nex;
					par[nex] = cur;
					depth[nex] = depth[cur] + 1;
				}
			}
		}
		return new int[][] { par, q, depth };
	}

	static int[][] packU(int n, int[] from, int[] to) {
		int[][] g = new int[n][];
		int[] p = new int[n];
		for (int f : from)
			p[f]++;
		for (int t : to)
			p[t]++;
		for (int i = 0; i < n; i++)
			g[i] = new int[p[i]];
		for (int i = 0; i < from.length; i++) {
			g[from[i]][--p[from[i]]] = to[i];
			g[to[i]][--p[to[i]]] = from[i];
		}
		return g;
	}
	
		public static class Node
		{
			public int val;
			public Node left, right, parent;
			public Node exparent;
			
			public int size;
			
			public int sumexsize;
			public int exsize;
			
			public Node(int val)
			{
				this.val = val;
				update();
			}
			
			public void update()
			{
				this.sumexsize = this.exsize + exsize(left) + exsize(right);
				this.size = 1 + size(left) + size(right);
			}

			@Override
			public String toString() {
				return "Node [val=" + val + ", size=" + size
						+ ", exsize=" + exsize
						+ ", sumexsize=" + sumexsize
						+ ", exparent=" + (exparent != null) + "]";
			}

			public String toString(String indent) {
				StringBuilder builder = new StringBuilder();
				if(left != null)builder.append(left.toString(indent + "  "));
				builder.append(indent).append(this.toString()).append("\n");
				if(right != null)builder.append(right.toString(indent + "  "));
				return builder.toString();
			}
		}
		
		public static Node expose(Node x)
		{
			if(x == null)return null;
			while(splay(x).exparent != null)promote(x);
			return x;
		}
		
		private static void promote(Node x)
		{
			Node xp = x.exparent;
			splay(xp);
			xp.exsize -= size(x) + exsize(x);
			xp.exsize += size(xp.right) + exsize(xp.right);
			Node xpr = xp.right;
			xp.right = x;
			x.parent = xp;
			x.exparent = null;
			if(xpr != null){
				xpr.exparent = xp;
				xpr.parent = null;
			}
			xp.update();
		}
		
		public static void cut(Node x)
		{
			expose(x);
			Node left = x.left;
			if(left != null)left.parent = null;
			x.left = null;
			x.update();
		}
		
		public static void link(Node par, Node ch)
		{
			expose(par);
			expose(ch);
			Node xpr = par.right;
			par.right = ch;
			ch.parent = par;
			
			if(xpr != null){
				xpr.exparent = par;
				xpr.parent = null;
				par.exsize += size(xpr) + exsize(xpr);
			}
			par.update();
		}
		
		public static Node root(Node x)
		{
			return first(expose(x));
		}
		
		public static boolean inSameLC(Node x, Node y)
		{
			return first(expose(x)).equals(first(expose(y)));
		}
		
		public static boolean inSameSplay(Node x, Node y)
		{
			Node rx = x, ry = y;
			while(rx.parent != null)rx = rx.parent;
			while(ry.parent != null)ry = ry.parent;
			boolean ret = rx.equals(ry);
			splay(x); splay(y);
			return ret;
		}
		
		public static Node lca(Node x, Node y)
		{
			expose(x);
			Node lastPromoted = null;
			while(splay(y).exparent != null){
				lastPromoted = y.exparent;
				promote(y);
			}
			if(inSameSplay(x, y)){
//			if(first(x).equals(first(y))){
				if(index(x) < index(y)){
					return x;
				}else{
					return y;
				}
			}else{
				return lastPromoted;
			}
		}
		
		public static void update(Node x, int v)
		{
			x.val = v;
			x.update();
			splay(x);
		}
		
		private static int size(Node n){ return n == null ? 0 : n.size; }
		private static int exsize(Node n){ return n == null ? 0 : n.sumexsize; }
		
		public static Node get(Node any, int K)
		{
			splay(any);
			if(K < 0 || K >= size(any))throw new IllegalArgumentException();
			Node cur = any;
			while(true){
				if(K == size(cur.left))break;
				if(K < size(cur.left)){
					cur = cur.left;
				}else{
					K -= size(cur.left) + 1;
					cur = cur.right;
				}
			}
			return splay(cur);
		}
		
		public static int index(Node x)
		{
			return size(splay(x).left);
		}
		
		public static Node first(Node any)
		{
			splay(any);
			while(any.left != null)any = any.left;
			return splay(any);
		}
		
		public static Node last(Node any)
		{
			splay(any);
			while(any.right != null)any = any.right;
			return splay(any);
		}
		
		public static Node erase(Node x)
		{
			splay(x);
			if(x.left != null)x.left.parent = null;
			if(x.right != null)x.right.parent = null;
			if(x.left != null){
				Node last = last(x.left);
				last.right = x.right;
				if(x.right != null)x.right.parent = last;
				last.update();
			}
			Node ret = x.left != null ? x.left : x.right;
			x.left = x.right = null;
			x.update();
			return ret;
		}
		
		public static void insert(Node any, int K, Node x)
		{
			splay(any);
			if(K < 0 || K > size(any))throw new IllegalArgumentException();
			if(any == null)return;
			Node cur = any;
			while(true){
				if(K == 0 && cur.left == null){
					cur.left = x;
					x.parent = cur;
					break;
				}
				if(K == size(cur) && cur.right == null){
					cur.right = x;
					x.parent = cur;
					break;
				}
				if(K <= size(cur.left)){
					cur = cur.left;
				}else{
					K -= size(cur.left) + 1;
					cur = cur.right;
				}
			}
			splay(x);
		}
		
		public static Node splay(Node x)
		{
			if(x == null)return null;
			while(x.parent != null){
				Node p = x.parent;
				if(p.parent == null){
					
					if(p.left == x)rotateRight(p);else rotateLeft(p);
				}else{
					Node g = p.parent;
					if(g.left == p){
						if(p.left == x){
							
							rotateRight(g); rotateRight(p);
						}else{
							
							rotateLeft(p); rotateRight(g);
						}
					}else{
						if(p.left == x){
							
							rotateRight(p); rotateLeft(g);
						}else{
							
							rotateLeft(g); rotateLeft(p);
						}
					}
				}
			}
			return x;
		}
		
		
		private static Node rotateRight(Node x)
		{
			if(x == null || x.left == null)return x;
			Node y = x.left;
			x.left = y.right;
			y.right = x;
			
			y.exparent = x.exparent;
			x.exparent = null;
			
			Node par = x.parent;
			if(par != null){
				if(par.left == x)par.left = y;
				if(par.right == x)par.right = y;
			}
			if(x.left != null)x.left.parent = x;
			x.parent = y;
			y.parent = par;
			
			x.update();
			y.update();
			
			return y;
		}
		
		
		private static Node rotateLeft(Node x)
		{
			if(x == null || x.right == null)return null;
			Node y = x.right;
			x.right = y.left;
			y.left = x;
			
			y.exparent = x.exparent;
			x.exparent = null;
			
			Node par = x.parent;
			if(par != null){
				if(par.left == x)par.left = y;
				if(par.right == x)par.right = y;
			}
			if(x.right != null)x.right.parent = x;
			x.parent = y;
			y.parent = par;
			
			x.update();
			y.update();
			
			return y;
		}
		
		
		public static Node[] nodes(Node any)
		{
			splay(any);
			int n = any.size;
			Node[] ret = new Node[n];
			dfsNodes(0, any, ret);
			return ret;
		}
		
		private static void dfsNodes(int offset, Node cur, Node[] ret)
		{
			if(cur == null)return;
			ret[offset + size(cur.left)] = cur;
			dfsNodes(offset, cur.left, ret);
			dfsNodes(offset+size(cur.left)+1, cur.right, ret);
		}
	
	void run() throws Exception
	{
		is = INPUT.isEmpty() ? System.in : new ByteArrayInputStream(INPUT.getBytes());
		out = new PrintWriter(System.out);
		
		long s = System.currentTimeMillis();
		solve();
		out.flush();
		if(!INPUT.isEmpty())tr(System.currentTimeMillis()-s+"ms");
	}
	
	public static void main(String[] args) throws Exception { new E2().run(); }
	
	private byte[] inbuf = new byte[1024];
	private int lenbuf = 0, ptrbuf = 0;
	
	private int readByte()
	{
		if(lenbuf == -1)throw new InputMismatchException();
		if(ptrbuf >= lenbuf){
			ptrbuf = 0;
			try { lenbuf = is.read(inbuf); } catch (IOException e) { throw new InputMismatchException(); }
			if(lenbuf <= 0)return -1;
		}
		return inbuf[ptrbuf++];
	}
	
	private boolean isSpaceChar(int c) { return !(c >= 33 && c <= 126); }
	private int skip() { int b; while((b = readByte()) != -1 && isSpaceChar(b)); return b; }
	
	private double nd() { return Double.parseDouble(ns()); }
	private char nc() { return (char)skip(); }
	
	private String ns()
	{
		int b = skip();
		StringBuilder sb = new StringBuilder();
		while(!(isSpaceChar(b))){ 
			sb.appendCodePoint(b);
			b = readByte();
		}
		return sb.toString();
	}
	
	private char[] ns(int n)
	{
		char[] buf = new char[n];
		int b = skip(), p = 0;
		while(p < n && !(isSpaceChar(b))){
			buf[p++] = (char)b;
			b = readByte();
		}
		return n == p ? buf : Arrays.copyOf(buf, p);
	}
	
	private char[][] nm(int n, int m)
	{
		char[][] map = new char[n][];
		for(int i = 0;i < n;i++)map[i] = ns(m);
		return map;
	}
	
	private int[] na(int n)
	{
		int[] a = new int[n];
		for(int i = 0;i < n;i++)a[i] = ni();
		return a;
	}
	
	private int ni()
	{
		int num = 0, b;
		boolean minus = false;
		while((b = readByte()) != -1 && !((b >= '0' && b <= '9') || b == '-'));
		if(b == '-'){
			minus = true;
			b = readByte();
		}
		
		while(true){
			if(b >= '0' && b <= '9'){
				num = num * 10 + (b - '0');
			}else{
				return minus ? -num : num;
			}
			b = readByte();
		}
	}
	
	private long nl()
	{
		long num = 0;
		int b;
		boolean minus = false;
		while((b = readByte()) != -1 && !((b >= '0' && b <= '9') || b == '-'));
		if(b == '-'){
			minus = true;
			b = readByte();
		}
		
		while(true){
			if(b >= '0' && b <= '9'){
				num = num * 10 + (b - '0');
			}else{
				return minus ? -num : num;
			}
			b = readByte();
		}
	}
	
	private static void tr(Object... o) { System.out.println(Arrays.deepToString(o)); }
}
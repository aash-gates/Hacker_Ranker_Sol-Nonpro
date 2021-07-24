

import java.util.Arrays;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Scanner;

public class Solution {
 String[] board;
 int[][] cost;
 int N;
 int M;
 static final int[] dx = { 1, 0, -1, 0 };
 static final int[] dy = { 0, -1, 0, 1 };
 static final char[] ch = { 'D', 'L', 'U', 'R' };

 public static void main(String[] args) {
  Solution main = new Solution();
  main.run();
  System.exit(0);
 }

 private void run() {
  Scanner in = new Scanner(System.in);
  N = in.nextInt();
  M = in.nextInt();
  int k = in.nextInt();
  board = new String[N];
  for (int i = 0; i < N; i++) {
   board[i] = in.next();
  }

  cost = new int[N][M];
  for (int i = 0; i < N; i++)
   // for (int j = 0; j < M; j++)
   Arrays.fill(cost[i], Integer.MAX_VALUE);

  int ret = bfs(k);
  if (ret == Integer.MAX_VALUE)
   ret = -1;

  System.out.println(ret);
 }

 private int bfs(int K) {
  Queue<Node> queue = new PriorityQueue<Node>();
  queue.add(new Node(0, 0, K, 0));
  while (!queue.isEmpty()) {
   Node node = queue.poll();
   int x = node.x;
   int y = node.y;
   int k = node.k;
   int cost = node.cost;

   this.cost[x][y] = Math.min(this.cost[x][y], cost);
   if (board[x].charAt(y) == '*' && k >= 0)
    return this.cost[x][y];
   else if (k < 0)
    continue;

   for (int i = 0; i < 4; i++) {
    int xx = x + dx[i];
    int yy = y + dy[i];
    if (inBoard(xx, yy)) {
     int c = board[x].charAt(y) == ch[i] ? 0 : 1;
     if (c + cost < this.cost[xx][yy])
      queue.add(new Node(xx, yy, k - 1, c + cost));
    }
   }
  }
  return -1;
 }

 private boolean inBoard(int x, int y) {
  return x >= 0 && x < N && y >= 0 && y < M;
 }
}

class Node implements Comparable<Node> {
 public int x;
 public int y;
 public int k;
 public int cost;

 public Node(int x, int y, int k, int c) {
  this.x = x;
  this.y = y;
  this.k = k;
  this.cost = c;
 }

 public int compareTo(Node node) {
  // if (this.cost != node.cost)
  return this.cost - node.cost;
  // if (this.k != node.k)
  // return this.k - node.k;
  // return this.x + this.y - node.x - node.y;
 }
}


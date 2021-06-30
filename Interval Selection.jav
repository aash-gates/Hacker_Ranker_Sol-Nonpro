import java.util.Scanner;
import java.util.Arrays;

class Solution{
    static int solve(int[][] intv){
        Arrays.sort(intv,(int[] a, int[] b)->a[1]-b[1]);
        int count=0, busy[][]=new int[2][2];
        for(int[] x: intv){
            if(x[0]>busy[1][1]){
                ++count;
                busy[1]=x;
            }else if(x[0]>busy[0][1]){
                ++count;
                busy[0]=x;
                if(x[1]>busy[1][1]){
                    int[] temp=busy[0];
                    busy[0]=busy[1];
                    busy[1]=temp;
                }
            }
        }
        return count;
    }
    public static void main(String[] args){
        Scanner sc=new Scanner(System.in);
        int s=sc.nextInt();
        while(s-- != 0){
            int n=sc.nextInt();
            int[][] intv=new int[n][2];
            for(int i=0;i<n;++i){
                intv[i][0]=sc.nextInt();
                intv[i][1]=sc.nextInt();
            }
            System.out.println(solve(intv));
        }
        sc.close();
    }
}
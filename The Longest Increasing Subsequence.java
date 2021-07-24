import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution. */
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        int[] arr1 = new int[n+1];
        int[] arr_M = new int[n+1];
        int[] arr_P = new int[n+1];
       
        for (int i = 0; i < n; i++) {
			arr1[i] = in.nextInt();
			
		}
        int max = 0;
        int newMax;
        for (int i = 0; i < n; i++) {
        	int low = 1;
        	int high = max;
        	while(low <= high)
        	{
        		int mid = (int) Math.ceil((low + high)/2);
        		if(arr1[arr_M[mid]] < arr1[i] )
        			low = mid + 1;
        		else
        			high = mid - 1;
        	}
        	newMax= low;
        	arr_P[i] = arr_M[newMax-1];
        	arr_M[newMax] = i;
        	if(newMax> max)
        		max = newMax;
        }
     
        
       System.out.println(max);
    }
}
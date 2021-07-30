import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution. */
        try{
		BufferedReader br = 
                      new BufferedReader(new InputStreamReader(System.in));
            int n = Integer.parseInt(br.readLine());
            String[] arrA = br.readLine().split(" ");
            int m = Integer.parseInt(br.readLine());
            String[] arrB = br.readLine().split(" ");
            
            int[] A = new int[n];
            int[] B = new int[m];
            HashMap<Integer,Integer> hA = new HashMap<Integer,Integer>();
            HashMap<Integer,Integer> hB = new HashMap<Integer,Integer>();
            ArrayList<Integer> missing = new ArrayList<Integer>(); 
            for(int i=0; i<n; i++)
            {
                A[i] = Integer.parseInt(arrA[i]);
                if(!hA.containsKey(A[i]))
                {
                    hA.put(A[i],1);
                }
                else
                {
                    hA.put(A[i], hA.get(A[i])+1);
                }
            }
            
            for(int i=0; i<m; i++)
            {
                B[i] = Integer.parseInt(arrB[i]);
                if(!hB.containsKey(B[i]))
                {
                    hB.put(B[i],1);
                }
                else
                {
                    hB.put(B[i], hB.get(B[i])+1);
                }
            }
            
            Iterator iterB = hB.entrySet().iterator();
            while(iterB.hasNext())
            {
                Map.Entry mapEntry = (Map.Entry) iterB.next();
                if(hA.containsKey(mapEntry.getKey()) && (Integer.parseInt(mapEntry.getValue().toString())-hA.get(mapEntry.getKey())==0))
                   {
                       
                   }
                else
                {
                    missing.add(Integer.parseInt(mapEntry.getKey().toString()));
                }
            }
            Collections.sort(missing);
            for(int i=0; i<missing.size(); i++)
            {
                System.out.print(missing.get(i)+" ");
            }
            
        }catch(IOException io)
        {
            io.printStackTrace();
        }
    }
}
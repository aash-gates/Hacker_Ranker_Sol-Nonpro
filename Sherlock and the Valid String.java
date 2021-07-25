import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner sc= new Scanner(System.in);
        String s = sc.next();
        int a[] = new int[26];
        boolean logic = true;
        for(int i=0;i<s.length();i++){
            a[s.charAt(i) - 'a']++;
        }
        Arrays.sort(a);
        int i = 25;
        while (i>=0 && a[i]!=0)
            i--;
        i++;
        if(a[i]==1){
            i++;
        }


        for(;i<25;i++){
            if(a[i]!=a[i+1]){
                if(i!=24){
                    logic = false;
                    break;
                }
                else{
                    if(a[i+1] != (a[i]+1)){
                        logic = false;
                        break;
                    }
                }

            }
        }
        if(logic){
            System.out.println("YES");
        }
        else
            System.out.println("NO");
    }
}
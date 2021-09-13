import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Drive {

    public static void main(String[] args)  {
        Scanner scan = new Scanner(System.in);
        
        step[] steps = new step[scan.nextInt()];
        passenger[] passengers = new passenger[scan.nextInt()];
        int nitro = scan.nextInt();
        
        loadStuff(scan,steps,passengers);
        addPassengers(steps,passengers);
        calcDepartures(steps);
        

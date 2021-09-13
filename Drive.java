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
        
        Queue<run> runs = new PriorityQueue();
        findruns(runs,steps);
        saveNitro(steps,runs,nitro);
        calcDepartures(steps);
        System.out.println(passengerTime(steps,passengers));
        
    }
    
    static void saveNitro(step[] steps,Queue<run> runs,int nitroLimit){
        long targetSaving = totalDistance(steps) - nitroLimit;
        run r;
        int s;
        int x;
        
        while(0<targetSaving){
            r = runs.poll();
            s = r.station;
            x = steps[s].distance - steps[s].travelTime;
            if(x>r.deadline){x=r.deadline;}
            if(x>targetSaving){x=(int)targetSaving;}
            

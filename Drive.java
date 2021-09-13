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
            
            steps[s].travelTime += x;
            r.deadline -= x;
            targetSaving -= x;
            if ((0<s) && (0 < r.deadline)){
                r.carrying += steps[s].dropped;
                r.station--;
                runs.add(r);
            }
        }
    }
    
    static long totalDistance(step[] steps){
        long distance=0;
        for(step s : steps){
            distance += s.distance;
        }
        return distance;
    }
    
    static void printruns(Queue<run> runs){
        for(run r : runs){
            System.out.println("~~~~~~~~");
            System.out.println("station : "+String.valueOf(r.station));
            System.out.println("deadline : "+String.valueOf(r.deadline));
            System.out.println("tocarry : "+String.valueOf(r.carrying));
        }
    }
    
    static void findruns(Queue<run> runs,step[] steps){
        steps[steps.length-1].departure = 2000000000;
        for(int i=0;i<steps.length-1;i++){
            if(steps[i].departure < steps[i+1].departure){
                run r = new run();
                r.station = i;
                r.deadline = steps[i+1].departure - steps[i].departure;
                r.carrying = steps[i+1].dropped;
                runs.add(r);
            }
        }
    }
    
    static long passengerTime(step[] steps,passenger[] passengers){
        long total = 0;
        for(passenger p : passengers){
            total += steps[p.dest-1].departure + steps[p.dest-1].travelTime - p.arrival;
        }
        return total;
    }
    
    
    static void calcDepartures(step[] steps){
        int t = 0;
        for (step s : steps){
            if(s.departure < t){
                s.departure = t;
            }else{
                t = s.departure;
            }
            t+=s.travelTime;
        }
    }
    
    static void addPassengers(step[] steps, passenger[] passengers){
        for (passenger p : passengers) {
            if(steps[p.start].departure < p.arrival){
                steps[p.start].departure = p.arrival;
            }
            steps[p.start].pickedUp++;
            steps[p.dest].dropped++;
        }
        
        int load=0;
        for (step s : steps){
            load += s.pickedUp - s.dropped;
            s.carried = load;
        }
    }
    
    static void loadStuff(Scanner scan,step[] steps, passenger[] passengers){
        for(int i=0;i<steps.length-1;i++){
            steps[i] = new step();

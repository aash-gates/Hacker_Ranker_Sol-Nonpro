<?php
 /* Enter your code here. Read input from STDIN. Print output to STDOUT */
    class XorComp {
    private $members;
    private $refinedmembers;
    private $entries;
    private $uniqueentries;
    private $uniquecount;
    private $useSimple;
    private $filterbits;
    private $refinedPossibles;
    private $refineduniques;

    //
    //  After constructor is done you will get 256 sorted $this->members based on the >> 7 
    //
    function __construct($e) {
        $this->members = array();
        $this->refinedmembers = array();
        $this->entries = array();
        $this->uniqueentries = array();
        $this->refineduniques = array();
        $hash = array();

        $filterbits = 256;
        foreach ($e as $entry) {
            $ent = (int)$entry;
            $this->entries[] = $ent;
        }

        for ($i=0; $i<256; $i++) {
            $this->members[$i] = array();
        }
        for ($i=0; $i<4096; $i++) {
            $this->refinedmembers[$i] = array();
            $this->refineduniques[$i] = 0;
        }

        $this->useSimple = false;
        $this->fillMembers($e);

        //printf("uniquecount = %d\n",$this->uniquecount);
    }

   private function fillMembers($entries) {
        for ($i=0; $i<count($entries); $i++) {
            $index = ((int)($entries[$i]))/128;
            array_push($this->members[$index],$i);
            $refinedindex = ((int)($entries[$i]))/8;
            array_push($this->refinedmembers[$refinedindex],$i);
            if (!array_key_exists($entries[$i],$this->uniqueentries)) {
                $this->uniqueentries{$entries[$i]} = true;
                $this->refineduniques[$refinedindex]++;
            }
            //printf("index = %d, i = %d, entry = %d\n",$index,$i,$entries[$i]);
            //printf("entering entry %d into member index %d\n",$i,$index);
        }
    }

    private function getslice($start, $end) {
        if (($start == 1) && ($end == count($this->entries))) {
            return ($this->uniqueentries);
        }
        else {
            $newarr = array();
            $hash = array();

            for ($i=$start-1; $i<$end; $i++) {
                $ent = $this->entries[$i];
                array_push($newarr,$ent);
                if (!array_key_exists($ent,$hash)) {
                     $hash{$ent} = true;
                     if (count($hash) == $this->uniquecount) {
                         break;
                     }
                }
            }
            return $newarr;
       }
   }

   private function bestXorSimple($num,$start,$end) {
        $best = -1;
        $arr = $this->getslice($start,$end);
        for ($i=0; $i<count($arr); $i++) {
            $curr = (int)$num ^ (int)$arr[$i];
            if ($curr > $best) {
                $best = $curr;
            }
        }
        return $best;
    }

   private function getCandidates($arr,$start,$end,$refined=false,$refinedbucket=0) {
        $startindex = 0;
        $length = count($arr)-1;
        $endindex = $length;
        $resultarr = array();
        //printf("getCandidates\n");

        if ($refined) {
            $refinedPossibles = min(8,$this->refineduniques[$refinedbucket]);
        }
        while ($endindex >= $startindex) {
            $currindex = (int)(($endindex-$startindex)/2+$startindex);
            $currval = $arr[$currindex];
            //printf("currindex %d, currval %d, start %d, end %d, startindex %d, endindex %d\n",
            //        $currindex,$currval,$start,$end,$startindex,$endindex);
            if ($start-1 > $currval) {
                $startindex = $currindex+1;
            }
            else if ($end-1 < $currval) {
                $endindex = $currindex-1;
            }
            else {
                //if (!array_key_exists($this->entries[$currval],$resultarr)) {
                     //printf("1.  inserting currval %d, entry %d\n",$currval,$this->entries[$currval]);
                $resultarr{$this->entries[$currval]} = true;
                //}
                $i = $currindex-1;
                while (($i>=0) && ($arr[$i] >= $start-1)) {
                    //printf("2. inserting i %d, entry %d\n",$i,$this->entries[$arr[$i]]);
                    //if (!array_key_exists($this->entries[$arr[$i]],$resultarr)) {
                    $resultarr{$this->entries[$arr[$i]]} = true;
                    if ($refined && (count($resultarr) == $refinedPossibles)) {
                        return $resultarr;
                    }
                    //}
                    $i--;
                }
                $i = $currindex+1;
                while (($i<=$length) && ($arr[$i] <= $end-1)) {
                    //printf("inserting i %d\n",$i);
                    //if (!array_key_exists($this->entries[$arr[$i]],$resultarr)) {
                    $resultarr{$this->entries[$arr[$i]]} = true;
                    if ($refined && (count($resultarr) == $refinedPossibles)) {
                        return $resultarr;
                    }
                    //}
                    $i++;
                }
                //print_r($resultarr);
                return $resultarr;
            }
            //printf("--> currindex %d, currval %d, start %d, end %d, startindex %d, endindex %d\n",
            //        $currindex,$currval,$start,$end,$startindex,$endindex);
            //printf("s %d, c %d, e %d\n",$startindex,$currindex,$endindex);
        }
        return $resultarr;
   }

   private function bestXorByFilter($num,$start,$end) {
        $found = false;
        $filter = 255;
        $maskednum = ((int)$num)/128 ;
        $refinedmaskednum = ((int)$num)/8;
        while (!$found) {
            $bucket = $maskednum ^ $filter;
            //printf("bucket is %d, maskednum=%d, filter=%d\n",$bucket,$maskednum,$filter);
            $arr = $this->members[$bucket];
            $filter--;

            $nbrentries = count($arr);
            if ($nbrentries > 0) {
                if ($nbrentries > 20) {
                     $iterations = 15;
                     $scaledbucket = $bucket*16;
                     $refinedbits = $refinedmaskednum % 16;
                     while (($iterations >= 0) && (!$found)) {
                         $refinedbucket = $scaledbucket + ($refinedbits ^ $iterations);
                         $arr = $this->refinedmembers[$refinedbucket];
                         $candidates = $this->getCandidates($arr,$start,$end,true,$refinedbucket);
                         $found = (count($candidates) > 0);
                         //if ($found) {
                         //     printf("Found candidates refinedBucket %d, bucket %d\n",$refinedbucket,$bucket);
                         //}
                         $iterations--;
                     }
                }
                else {
                     $candidates = $this->getCandidates($arr,$start,$end);
                     $found = (count($candidates) > 0);
                }
            }
        }

        // These are indices into the $this->entries
        $largest = -1;

        //printf("length of candidates: %d\n",count($candidates));
        foreach ($candidates as $entry => $val) {
            $curr_num = (int)$num ^ (int)$entry;
            if ($curr_num > $largest) {
                $largest = $curr_num;
            }
        }
        return $largest;
   }

   public function bestXor($a,$p,$q) {
        if ($this->useSimple) {
            return $this->bestXorSimple($a,$p,$q);
        }
        else {
            return $this->bestXorByFilter($a,$p,$q);
        }
   }
}

$fp = fopen('php://stdin','r');
$nbrtests = (int)trim(fgets($fp));

while ($nbrtests > 0) {

   list($N,$Q) = explode(" ",trim(fgets($fp)));
   $entries = explode(" ",trim(fgets($fp)));

   $x = new XorComp($entries);
   while ($Q > 0) {
      list($a,$p,$q) = explode(" ",trim(fgets($fp)));
      printf("%d\n",$x->bestXor($a,$p,$q));
      $Q--;
   }

   $members = null;
   $nbrtests--;
}

?>

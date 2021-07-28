<?php
    
function checkGotSame($s1,$s2){
    $slen = strlen($s1);
    if($slen == 1) {
        return ($s1 == $s2) ? 0:1;
    }
    $slen = floor($slen / 2);
    $s11 = substr($s1,0,$slen);
    $s12 = substr($s1,$slen);
    $s21 = substr($s2,0,$slen);
    $s22 = substr($s2,$slen);
    $count = 0;
    if($s11 != $s21) {
        $count += checkGotSame($s11,$s21);
    }
    if($s12 != $s22) {
        $count += checkGotSame($s12,$s22);
    }
    return $count;
    
}
$_fp = fopen("php://stdin", "r");
/* Enter your code here. Read input from STDIN. Print output to STDOUT */
$t = (int)trim(fgets($_fp));
while($t-- > 0){
    $te = explode(' ', trim(fgets($_fp)));
    $p = $te[0];
    $v = $te[1];
    $lenP = strlen($p);
    $lenV = strlen($v);
    $trapV = $lenP - $lenV; // Incase got error
    $output = [];
    if($lenV > 1) {

        $vg = [];
        $lv = $v[2];
        $lvs = 2;
        for($i = 3; $i < $lenV; $i++) {
            $cv = $v[$i];

            if($cv == $lv)
                continue;

            $vg[] = [$lv, $lvs, $i - $lvs];

            $lv = $cv;
            $lvs = $i;
        }
            
        $vg[] = [$lv, $lvs, $lenV - $lvs];

        if(count($vg) > 1000 && count($vg) > $lenV / 2) {
            $traP = $trapV + 1;
            if(strlen($v) == 1) {
                for($all = 0; $all < $traP; $all++) {
                    $output[] = $all;
                }
                $traP = -1;
            }
            $listOfFirstOcc = [];
            $start = 0;
            $in = strpos($p, $v[0], $start); 
            while($in !== false) {
                if($in >= $traP)
                    break;
                $listOfFirstOcc[$in] = $in;
                $start = $in + 1;
                $in = strpos($p, $v[0], $start); 
            }
            $start = 0;
            $in = strpos($p, $v[1], $start); 
            while($in !== false) {
                if($in - 1>= $traP)
                    break;
                if($in != 0) 
                    $listOfFirstOcc[$in - 1] = $in - 1;
                $start = $in + 1;
                $in = strpos($p, $v[1], $start); 
            }
            asort($listOfFirstOcc);
            //for($i = 0; $i < $traP; $i++) {
            //echo implode(' ' ,$listOfFirstOcc) . PHP_EOL;continue;
            foreach($listOfFirstOcc as $i => $noUse) {
                if($p[$i] == $v[0] &&
                    (
                        $p[$i + $lenV - 1] == $v[$lenV - 1] ||
                        $p[$i + $lenV - 2] == $v[$lenV - 2] // Incase error at last
                    )
                  ) { 
                    $s1 = substr($p,$i,$lenV);
                    if(checkGotSame($s1,$v) < 2) {
                        $output[] = $i;
                        continue;   
                    }
                }
                if($p[$i] == $v[1] ) { // incase error;
                    //Same
                    $resV = substr($v, 1);
                    $resP = substr($p, $i + 1,strlen($resV));
                    if($resP == $resV) {
                        // Same all with error
                        $output[] = $i;
                    }
                }
                else if($p[$i + 1] == $v[1]) { // incase error;
                    //Same
                    $resV = substr($v, 2);
                    $resP = substr($p, $i + 2,strlen($resV));
                    if($resP == $resV) {
                        // Same all with error
                        $output[] = $i;
                    }
                }
            }
        }
        else {
            $pArr = [];
            $lp = $p[0];
            $lps = 0;
            for($i = 0; $i < $lenP; $i++) {
                $cp = $p[$i];
                if($cp == $lp)
                    continue;

                $csame = $i - $lps;
                for($j = $lps; $j < $i; $j++){
                    $pArr[$j] = [$lp, $csame--];
                }

                $lp = $cp;
                $lps = $i;
            }
            $csame = $lenP - $lps;
            for($j = $lps; $j < $lenP; $j++){
                $pArr[$j] = [$lp, $csame--];
            }


            $remainArray = [];
            $cv1 = $v[0];
            $cv2 = $v[1];
            for($i = 0; $i <= $trapV + 1; $i++){
                if($p[$i] == $cv1 && $i <= $trapV){
                    $remainArray[$i] = 0;
                }
                if($i > 0) {
                    if($p[$i] == $cv2) {
                        if(!isset($remainArray[$i - 1])) {
                            $remainArray[$i - 1] = 1;       
                        }
                    }
                    else {
                        if(isset($remainArray[$i - 1])) {
                            $remainArray[$i - 1] = 1;       
                        }    
                    }   
                }
            }
            foreach($remainArray as $sp => &$rem) {
                foreach($vg as $gro => $val) {
                    $vc = $val[0];
                    $vsp = $val[1];
                    $vneed = $val[2];
                    $vep = $vsp + $vneed;

                    $psp = $sp + $vsp;
                    while($vneed > 0) {
                        if($pArr[$psp][0] == $vc) {
                            if($pArr[$psp][1] >= $vneed) {
                                $vneed = 0;
                                continue;
                            }
                            else {
                                $vneed -= $pArr[$psp][1];
                                $psp += $pArr[$psp][1];
                                continue;
                            }
                        }
                        else {  
                            $vneed--;
                            $remainArray[$sp]++;
                            $psp++;
                            continue;
                        }
                        if($remainArray[$sp] > 1)
                            break;
                        
                    }

                    if($remainArray[$sp] > 1)
                        break;
                }

                if($remainArray[$sp] > 1) {
                    unset($remainArray[$sp]);
                }
            }
            $output = [];
            foreach($remainArray as $key => $val){
                $output[] = $key;
            }
            asort($output);
        }
    }
    else {
        $output = [];
        for($i = 0; $i < $lenP; $i++){
            $output[] = $i;
        }
    }
    if(empty($output)){
        echo "No Match!" . PHP_EOL;
    }
    else {
        //echo 'done'.PHP_EOL;
        echo implode(' ', $output) . PHP_EOL;
    }
}
?>
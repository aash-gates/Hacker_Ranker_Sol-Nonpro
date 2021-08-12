open Int64
exception Exp
type element = int
type node = {mutable parent : element;
						 mutable rank : int}

type universe = node array

let createUniverse (size : int) : universe =
  Array.init size (fun i -> {parent = i; rank = 1})

let rec find (s : universe) (e : element) : element =
	let n = Array.get s e in
		if n.parent = e then e
		else
			(n.parent <- (find s n.parent);
			 n.parent)

let union (s : universe) (e1 : element) (e2 : element) : unit =
  let r1 = find s e1 in
  let r2 = find s e2 in
	let n1 = s.(r1) in
	let n2 = s.(r2) in
    if r1 <> r2 then
        if n1.rank < n2.rank then
			    (n1.parent <- r2)
		    else
			    (n2.parent <- r1;
			     if n1.rank = n2.rank then
				     n1.rank <- n1.rank + 1)
    
let split (s:string): (int * int) =
    let i = String.index s ' ' in
    (int_of_string (String.sub s 0 i), int_of_string (String.sub s (i+1) ((String.length s) - i - 1)))

let main = 
    let (n,i) = split (input_line stdin) in
    let k = ref i in
    let u = createUniverse n in
    begin
        try
            while (!k) > 0 do
                let (a,b) = split (input_line stdin) in
                union u a b;
                k := !k - 1;
            done;
        with
            End_of_file -> ();
    end;
    let h = Hashtbl.create 16 in
    for i = 0 to n-1 do
        let parent = find u i in
        let p = if Hashtbl.mem h parent then Hashtbl.find h parent else 0 in
        Hashtbl.replace h parent (p+1);
    done;
    let y = n * (n-1) / 2 in if y < 0 then 
    let i = of_int n in let y = div (mul i (sub i one)) (succ one) in
    let p = (Hashtbl.fold (fun k v init -> 
        if v < 2 then init else sub init (of_int (v * (v-1)/2))) h y) in
    print_endline (to_string p)
    else print_int (Hashtbl.fold (fun k v init -> if v < 2 then init else init - (v * (v-1)/2)) h y)
    
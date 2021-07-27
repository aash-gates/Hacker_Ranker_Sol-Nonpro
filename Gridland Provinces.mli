(* -*- mode: caml; coding: us-ascii; indent-tabs-mode: nil -*-
   vim: set filetype=ocaml fileencoding=utf-8 expandtab sw=2 sts=2:

   https://www.hackerrank.com/challenges/gridland-provinces
   SE, created 27-Jun-2021, in Ocaml 4.02.3.
*)

(* -- Utilities -- *)

module A = Array;;
module H = Hashtbl;;
module S = String;;
module T = Set.Make(String);;

let prf = Printf.printf;;
let fprf = Printf.fprintf;;

let code c = Char.code c - Char.code 'a';;

let chr x = Char.chr (Char.code 'a' + x);;

(* -- Algorithm -- *)

(* The minimal paths in gridland visit each city exactly once, think
   of a cyclic one. This means we are to consider the words of all
   directed hamiltonian paths. The total number of them (2 x A003682)
   is 2 (n^2 - n + 2) for n >= 2.

   The general form of a hamiltonian path on the 2 x n grid is:
   (1) loop to one side for A columns,
   (2) wiggle for B columns,
   (3) loop to the other side for C columns,
   where A + B + C = n and A, B, C in {0..n}.

   This means that the word for a path consists of up to three parts,
   each of which is a substring of some fixed string which does not
   depend on the path. We assemble these fixed strings into a single
   'omnibus' string so that we can address it easily.

   The triples of substrings of the omnibus string are enumerated,
   and for each each triple the hash of the concatenated string is
   determined in constant time by using a suitable hash function.

   This results in a O(n^2) algorithm for computing a lower bound
   of the number of words, since there is a (small) probability of
   a hash collision. For the purpose of this exercise we ignore it.
*)

let nmax = 600;; (* consider n in {1..nmax} *)

(* -- Hashing -- *)

(* Hash function h(x) = Sum(x[i] a^i : i in {0..#x-1}) mod M, for M = 2^63.
   This structure allows us to find hashes of substrings of a fixed string quickly
   by precomputing h(x[0..k-1]), k in {0..n}, the hashes of all prefixes.

   The generator a in {0..M-1} is chosen coprime to M and of relatively
   large order modulo M, which is at most Phi(Phi(M)).
*)

assert (1 lsl 61 > 0 && 1 lsl 62 < 0);; (* need 63-bit signed int *)

let hash_m = (1 lsl 62) - 57;; (* largest prime below 2^62 *)

let hash_a = 41;; (* some value >26 *)

let inv_hash_a = 2699523522981885569;; (* = PowerMod(a, -1, M) *)

let add_mod_m x y = (* x, y in {0..M-1} *)
  let s = x + y in (* in {-116..2^62-1} *)
  if s >= 0 then (if s < hash_m then s else s - hash_m)
  else let t = s + 114 in (if s >= 0 then t else t + hash_m);;

let sub_mod_m x y = (* x, y in {0..M-1} *)
  if y = 0 then x else add_mod_m x (hash_m - y);;

let mul_mod_m x y = (* x, y in {0..M-1} *)
  (* Split using L = 2^31. Note L^2 mod M = 57. *)
  let mask = 2147483647 in (* = L-1 *)
  let x1 = x lsr 31 and x0 = x land mask (* x1, x0 <= L - 1 *)
  and y1 = y lsr 31 and y0 = y land mask (* y1, y0 <= L - 1 *)
  in (* x y = (x1 L + x0)(y1 L + y0) *)
  let u2 = x1*y1                     (* <= (L - 1)^2 *)
  and u1 = add_mod_m (x1*y0) (x0*y1) (* <= M - 1 *)
  and u0 = x0*y0                     (* <= (L - 1)^2 *)
  in (* x y = u2 57 + u1 L + u0 mod M *)
  let v1 = u2 + (u1 lsr 31)                     (* <= L (L - 1) *)
  and v0 = add_mod_m u0 ((u1 land mask) lsl 31) (* <= M - 1 *)
  in (* x y = v1 57 + v0 mod M *)
  (* Split v1 using B = 29 57^-1 mod M. *)
  let b = 80906772253112068 in
  let w1 = v1/b and w0 = v1 mod b in (* w1 in {0..56}, w0 in {0..B-1} *)
  add_mod_m (add_mod_m (w1*29) (w0*57)) v0;;

let hash s = (* for debugging *)
  let n = S.length s in
  let rec loop i ai acc =
    if i = n then acc
    else loop (i + 1) (mul_mod_m ai hash_a)
              (add_mod_m acc (mul_mod_m (code s.[i]) ai))
  in
  loop 0 1 0;;

let max_strlen = 24*nmax;; (* length of the longest string used *)

let pow_a = (* pow_a k = a^k mod M, for |k| <= max_strlen *)
  let a = A.make (2*max_strlen + 1) 1 in
  for k = 1 to max_strlen do
    a.(max_strlen + k) <- mul_mod_m a.(max_strlen + k - 1) hash_a;
    a.(max_strlen - k) <- mul_mod_m a.(max_strlen - k + 1) inv_hash_a
  done;
  fun k -> a.(max_strlen + k);;

let prefix_hashes s = (* ph[k] = hash(s[0..k-1]), k in {0..#s} *)
  let n = S.length s in
  let ph = A.make (n + 1) 0 in
  for k = 0 to n - 1 do
    ph.(k + 1) <- add_mod_m ph.(k) (mul_mod_m (code s.[k]) (pow_a k))
  done;
  ph;;

let hash1 ph_s i n = (* hash(s[i..i+n-1]) *)
  mul_mod_m (sub_mod_m ph_s.(i + n) ph_s.(i)) (pow_a (-i));;

(* hash(s[i1..i1+n1-1] s[i2..i2+n2-1] s[i3..i3+n3-1]) *)
let hash3 ph_s i1 n1 i2 n2 i3 n3 =
  let h1 = hash1 ph_s i1 n1 and a1 = pow_a n1
  and h2 = hash1 ph_s i2 n2 and a2 = pow_a n2
  and h3 = hash1 ph_s i3 n3 in
  add_mod_m h1 (mul_mod_m a1 (add_mod_m h2 (mul_mod_m a2 h3)));;

(* -- Enumerating hamiltonian paths -- *)

let rev s = (* reversed string *)
  let n = S.length s in
  S.init n (fun i -> s.[n-1 - i]);;

let wiggle p0 p1 = (* alternating path *)
  let n = S.length p0 in
  S.init (2*n) (fun i ->
    match i mod 4 with
    | 0 | 3 -> p0.[i/2]
    | _     -> p1.[i/2]
  );;

let omnibus_string p = (* combined string to be used for substrings *)
  let p0 = p.(0)  and p1 = p.(1)  in              (* length n *)
  let r0 = rev p0 and r1 = rev p1 in              (* length n *)
  let r1p0r0p1 = r1 ^ p0 ^ r0 ^ p1                (* length 4 n *)
  and w0110 = (wiggle p0 p1) ^ (wiggle p1 p0)     (* length 4 n *)
  and p0r1p1r0 = p0 ^ r1 ^ p1 ^ r0 in             (* length 4 n *)
       r1p0r0p1  ^      w0110  ^      p0r1p1r0  ^
  (rev r1p0r0p1) ^ (rev w0110) ^ (rev p0r1p1r0);; (* length 24 n *)

let iter_hamiltonian_words f n = (* call f for all triples of substrings *)
  (* This enumeration considers 12 paths twice. *)
  for a = 0 to n do
    for b = 0 to n - a do
      if not ( b > 0 && ( a = 1 || n - b - a = 1 ) ) then begin
        let c = n - a - b in
        let na = 2*a and nb = 2*b and nc = 2*c in
        for ud = 0 to 1 do
          let a1 = (a land 1) lxor ud
          and b1 = (b land 1) lxor ud in
          let ia = n - a + ud*2*n + 0*n
          and ib = 2*a   + a1*2*n + 4*n
          and ic = a + b + b1*2*n + 8*n in
          f ia na ib nb ic nc;
          (* reversed *)
          let ic = 12*n + 8*n + 4*n - 2*c - (a + b + b1*2*n)
          and ib = 12*n + 4*n + 4*n - 2*b - (2*a   + a1*2*n)
          and ia = 12*n + 0*n + 4*n - 2*a - (n - a + ud*2*n) in
          f ic nc ib nb ia na
        done
      end
    done
  done;;

let gridland p =
  let n = S.length p.(0) in
  let q = omnibus_string p in
  let ph_q = prefix_hashes q in
  let npaths = if n = 1 then 2 else 2*(n*n - n + 4) in
  let words = H.create (npaths + 12) in
  iter_hamiltonian_words (fun ia na ib nb ic nc ->
    let h = hash3 ph_q ia na ib nb ic nc in
    (* assert (h = hash ((S.sub q ia na) ^ (S.sub q ib nb) ^ (S.sub q ic nc))); *)
    H.replace words h ()
  ) n;
  H.length words;;

(* -- Validation -- *)

let gridland_simple p = (* for debugging *)
  let n = S.length p.(0) in
  let q = omnibus_string p in
  let words = ref T.empty in
  iter_hamiltonian_words (fun ia na ib nb ic nc ->
    let w = (S.sub q ia na) ^ (S.sub q ib nb) ^ (S.sub q ic nc) in
    words := T.add w !words
  ) n;
  T.cardinal !words;;

let check_p p =
  fprf stderr "("; flush stderr;
  let actual = gridland p in
  fprf stderr "."; flush stderr;
  let expected = gridland_simple p in
  fprf stderr ")"; flush stderr;
  if not ( actual = expected ) then begin
    fprf stderr "\n*** FAILED: gridland [|\"%s\"; \"%s\"|] = %d <> %d\n"
      p.(0) p.(1) actual expected
  end;;

let check_all_unary max_n =
  for n = 1 to max_n do
    for x = 0 to 25 do
      let p0 = S.make n (chr x) in
      check_p [| p0; p0 |]
    done
  done;;

let random_perm n =
  let x = A.init n (fun i -> i) in
  for k = n - 1 downto 1 do
    let i = Random.int (k + 1) in
    let xi = x.(i) in x.(i) <- x.(k); x.(k) <- xi
  done; x;;

let check_random_p letters min_n max_n iters =
  for iter = 1 to iters do
    fprf stderr " %d" iter; flush stderr;
    let n = min_n + Random.int (max_n - min_n + 1) in
    let x = random_perm 26 in
    let c = S.init letters (fun i -> chr x.(i)) in
    let p = A.init 2 (fun _ -> S.init n (fun _ -> c.[Random.int letters])) in
    check_p p
  done;;

(* -- I/O and driver -- *)

let main () =
  for _ = 1 to Scanf.scanf "%d" (fun p -> p) do
    let n = Scanf.scanf " %d" (fun n -> n) in
    let p0 = Scanf.scanf " %s" (fun p -> p) in
    let p1 = Scanf.scanf " %s" (fun p -> p) in
    assert (S.length p0 = n && S.length p1 = n);
    let p = [| p0; p1 |] in
    prf "%d\n" (gridland p)
  done;;

if not !Sys.interactive then main ();;

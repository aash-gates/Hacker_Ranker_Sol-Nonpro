(* -*- mode: caml; coding: us-ascii; indent-tabs-mode: nil -*-
   vim: set filetype=ocaml fileencoding=utf-8 expandtab sw=2 sts=2:

   https://www.hackerrank.com/challenges/similar-strings
   SE, created 13-Oct-2016, in Ocaml 4.02.3.
*)

(* -- Utilities -- *)

module A = Array;;
module B = Bytes;;
module S = String;;

let prf = Printf.printf;;
let fprf = Printf.fprintf;;

let code c = Char.code c - Char.code 'a';;

let chr x = Char.chr (Char.code 'a' + x);;

(* -- Algorithm -- *)

(* Instead of 1 <= li <= ri <= #s, we work with 0-based indices
   and represent substrings by (i, n) for s[i..i+n-1].
*)

(* A coloring is a permutation of the letters, represented by a
   string col of all letters in permuted order, where col[c]
   is the image of letter c. Let q be the number of letters.

   A canonical coloring of a string s maps the letters such that
   the mapped string is lexicographically least under all permutations.
   We call the mapped string the canonical image of s and write s'.
      This means, s[0] is mapped into 'a', the next new letter in s
   is mapped into 'b' and so on.

   The canonical coloring col(s) of a string is the lexicographically
   least canonical coloring, i.e., with letters not appearing in s being
   mapped to the least remaining letters.

   Lemma 1: Strings s and t are similar iff s' = t'.
   Proof: By induction over the string length.

   As the canonical coloring can be found in O(n + q), this gives us
   a way to decide similarity in O(n + q), improved from O(n^2).

   Lemma 2: A canonical coloring of a string is also canonical for
            any prefix of that string.
   Proof: Trivial.

   This allows us to compute all canonical colorings for the suffixes
   of a given string in O(n q). We start at the end of the string and
   proceed towards the front.

   Now consider the set {s[i..]' : i in {0..n-1}} of the canonical
   images of all suffixes of s. Each string is identified by its
   index i, so we can construct a data structure similar to a suffix
   array, but for the canonical images: csuftab[r] = i is the index
   of the rank r canonical suffix image s[i..]'. The inverse table
   is csufinv where csufinv[csuftab[r]] = r for all r. In addition,
   we construct the LCP array clcp, giving the longest prefix of the
   canonical images: clcp[r] = LCP(s[suftab[r]..]', s[suftab[r+1]..]')
   for r < n - 1.

   Given a substring s[i..i+n-1], we can find the rank r = csufinv[i]
   of the canonical suffix image s[i..]'. Then all strings that are
   similar to s[i..i+n-1] have adjacent rank, and the LCP array tells
   us how far to count. This means each query (li, ri) can be answered
   in time O(n) with small constant factors, after precomputing the
   tables csufinv and clcp, which require O(n) additional storage.

   It remains to find efficient algorithms for csuftab and clcp.

   The GetHeight algorithm of Kasai et al., 2001, computes lcp from
   suftab (and sufinv) in linear time. It uses the fact that suffixes
   that are adjacent in index share a large prefix with their successor
   in rank. This does not hold for clcp in general, but the following
   fact allows us to use at least a part of the prefix structure.

   Lemma 3: Consider strings s and t with a common prefix of length h.
            Then s' have t' also share a prefix of length h.
   Proof: By induction over h.

   Unfortunately, this is ineffective, at least for random texts
   since the useful prefixes are too short.

   Consider S = {s[i..]' : i}. Each image s[i..]' starts with a, since
   all strings are non-empty. Taking this further, we see that each
   string s[i..#s-1]' = a^(#s-i) or s[i..#s-1]' = a^m b w, for some
   m >= 1 and some rest word w in {a..}^(#s - m - 1). This gives us
   a way to sort at least partially, by sorting S into bins. Finding
   the strings in a^+ is trivial since they are at the end of s.
   Sorting the other strings by their a^+ b prefix takes linear time,
   since s[i..]' = a^m b w for m >= 2 implies s[i+1..]' = a^(m - 1) b w.
*)

let letters = 10;; (* letters 'a' .. 'j' are allowed in the input *)

(* -- Permutations of {0..letters-1}, packed into a single int -- *)

type perm = int;; (* = Sum(p[x] 16^x : x in {0..letters-1}) *)

let get p x = (p lsr (x lsl 2)) land 15;; (* p[x] *)

let set p x y = p lor (y lsl (x lsl 2));; (* p lor (p[x] = y) *)

let init_perm f = (* make permutation x -> p[x] = f x *)
  let rec loop x p =
    if x < 0 then p else loop (x - 1) ((p lsl 4) lor (f x))
  in
  loop (letters - 1) 0;;

let iteri_perm f p = (* call f x p[x] for all x *)
  let rec loop x p =
    if x < letters then begin
      f x (p land 15);
      loop (x + 1) (p lsr 4)
    end
  in
  loop 0 p;;

let id_perm = init_perm (fun x -> x);; (* identity *)

let mul_perm p q = init_perm (fun x -> get p (get q x));; (* p q *)

let inv_perm p = (* p^-1 *)
  let rec loop x inv_p =
    if x = letters then inv_p
    else loop (x + 1) (set inv_p (get p x) x)
  in
  loop 0 0;;

(* -- Canonical colorings of suffixes -- *)

let canonical_suffix_colorings s = (* col(s[i..]) for all i in {0..n-1} *)
  let n = S.length s in
  let ps = A.make n id_perm in
  let rec loop i p inv_p = (* p = col(s[i+1..]) *)
    if i >= 0 then begin
      (* map s[i] to 0 and shift the others *)
      let si = code s.[i] in
      let p_si = get p si in
      if p_si = 0 then begin
        ps.(i) <- p;
        loop (i - 1) p inv_p
      end else begin
        let next_inv_p = init_perm (fun x ->
          if x = 0 then si
          else if x <= p_si then get inv_p (x - 1)
          else get inv_p x
        ) in
        let next_p = inv_perm next_inv_p in
        ps.(i) <- next_p;
        loop (i - 1) next_p next_inv_p
      end
    end
  in
  loop (n - 1) id_perm id_perm;
  ps;;

let get_canonical s csc i k = (* k-th letter of s[i..]', k in {0..#s-i-1} *)
  chr (get csc.(i) (code s.[i + k]));;

let canonical s csc i n = (* s[i..i+n-1]' *)
  S.init n (get_canonical s csc i);;

(* -- Suffix array, inverse and LCP array for the colored images -- *)

let colored_suffix_array_simple s csc = (* O(n^2 log n) *)
  let n = S.length s in
  let a = A.init n (fun i -> (canonical s csc i (n - i), i)) in
  A.fast_sort Pervasives.compare a;
  A.map (fun (_, i) -> i) a;;

let inverse_colored_suffix_array csuftab = (* O(n) *)
  let csufinv = A.make (A.length csuftab) 0 in
  A.iteri (fun r i -> csufinv.(i) <- r) csuftab;
  csufinv;;

let colored_lcp_array_simple s csc csuftab csufinv = (* O(n^2) *)
  let n = S.length s
  and s' i k = get_canonical s csc i k
  in
  let rec lcp k i1 i2 m =
    if k < m && s' i1 k = s' i2 k then lcp (k + 1) i1 i2 m else k
  in
  A.init (n - 1) (fun r ->
    let i1 = csuftab.(r) and i2 = csuftab.(r + 1) in
    lcp 0 i1 i2 (n - max i1 i2));;

let compare_csuf s csc k i1 i2 = (* compare s[i1..]' s[i2..]' for letters >= k *)
  let n = S.length s
  and s' i k = get_canonical s csc i k in
  let nmin = n - max i1 i2
  in
  let rec loop k =
    if k < nmin then
      let x1 = s' i1 k and x2 = s' i2 k in
      if x1 < x2 then -1
      else if x1 > x2 then 1
      else loop (k + 1)
    else
      if k = n - i1 then -1 else 1
  in
  if i1 = i2 then 0 else loop k;;

let lcp_csuf s csc k i1 i2 = (* lcp(s[i1..]', s[i2..]') >= k *)
  let n = S.length s
  and s' i k = get_canonical s csc i k in
  let nmin = n - max i1 i2
  in
  let rec loop k =
    if k < nmin && s' i1 k = s' i2 k then loop (k + 1) else k
  in
  if i1 = i2 then nmin else loop k;;

let colored_suffix_array_with_lcp s csc =
  let n = S.length s
  and s' i k = get_canonical s csc i k
  in (* s[i..]' = a^(n - i) for i in {n-t..n-1} *)
  let t = ref 1 in
  while !t < n && s.[n - (!t + 1)] = s.[n - 1] do incr t done;
  let t = !t
  in (* bins[m] = {i : s'[i..]' = a^m b ..}, for m in {1..n-t-1} *)
  let bins = A.make (n - t) [] in
  let i = ref 0 in
  while !i < n - t do
    let m = ref 1 in
    while s' !i !m = 'a' do
      incr m
    done;
    while !m >= 1 do
      bins.(!m) <- !i :: bins.(!m);
      decr m;
      incr i
    done;
  done;
  (* sort the bins, using the known prefix lengths *)
  let nbins = A.length bins in
  let b = A.make nbins [| |] in
  for m = 1 to nbins - 1 do
    if bins.(m) <> [] then begin
      b.(m) <- A.of_list bins.(m);
      A.fast_sort (compare_csuf s csc (m + 1)) b.(m)
    end
  done;
  (* combine the bins *)
  let csuftab = A.init n (fun r -> n-1 - r)
  and ncsuftab = ref t  in
  for m = nbins - 1 downto 1 do
    let bm = b.(m) in
    let nbm = A.length bm in
    A.blit bm 0 csuftab !ncsuftab nbm;
    ncsuftab := !ncsuftab + nbm
  done;
  assert (!ncsuftab = n);
  (* use bins for faster LCP construction *)
  let clcp = A.init (n - 1) (fun r -> r + 1)
  and nclcp = ref (t - 1) in
  for m = nbins - 1 downto 1 do
    let bm = b.(m) in
    let nbm = A.length bm in
    let r0 = !nclcp in
    clcp.(r0) <- lcp_csuf s csc 1 csuftab.(r0) csuftab.(r0 + 1);
    for r = r0 + 1 to !nclcp + nbm - 1 do
      clcp.(r) <- lcp_csuf s csc (m + 1) csuftab.(r) csuftab.(r + 1)
    done;
    nclcp := !nclcp + nbm
  done;
  assert (!nclcp = n - 1);
  csuftab, clcp;;

(* -- Caching the precomputed data -- *)

type similar_strings_data = (* precomputed from s *)
  { s       : string;    (* the string, as key for cache *)
    csc     : int array; (* canonical suffix colorings, col(s[i..]) *)
    csuftab : int array; (* colored suffix table, s[i..]' by rank *)
    csufinv : int array; (* inverse of colored suffix table *)
    clcp    : int array; (* longest common prefix clcp[r] for r and r+1 *)
  };;

let compute_similar_strings_data s =
  let csc = canonical_suffix_colorings s in
  let csuftab, clcp = colored_suffix_array_with_lcp s csc in
  let csufinv = inverse_colored_suffix_array csuftab in
  (*
  assert (csuftab = colored_suffix_array_simple s csc);
  assert (clcp = colored_lcp_array_simple s csc csuftab csufinv);
  *)
  {s; csc; csuftab; csufinv; clcp};;

let similar_strings_data =
  let compute = compute_similar_strings_data in
  let cache = ref (compute "a") in
  fun s ->
    if !cache.s <> s then cache := compute s;
    !cache;;

(* -- Combinatorics -- *)

let similar_strings s li ri =
  let ns = S.length s
  and {csc; csuftab; csufinv; clcp} = similar_strings_data s
  in (* precomputation done *)
  let i = li - 1 in
  let n = ri - li + 1
  in (* count {j : s[j..j+n-1] similar to s[i..i+n-1]} *)
  let r = csufinv.(i) in
  let r1 = ref r in
  while !r1 > 0 && clcp.(!r1 - 1) >= n do decr r1 done;
  let r2 = ref r in
  while !r2 < ns - 1 && clcp.(!r2) >= n do incr r2 done;
  !r2 - !r1 + 1;;

(* -- Validation -- *)

let is_similar s i j n = (* Is s[i..i+n-1] similar to s[j..j+n-1]? *)
  let ns = S.length s in
  assert (n >= 0 && 0 <= i && i + n <= ns && 0 <= j && j + n <= ns);
  let rec loop x y = (* 0 <= x < y < n *)
    y >= n ||
    ( if x = y then loop 0 (y + 1)
      else (s.[i + x] = s.[i + y]) = (s.[j + x] = s.[j + y]) &&
           loop (x + 1) y )
  in
  loop 0 1;;

let similar_strings_simple s li ri = (* using definition, O(n^3) *)
  let ns = S.length s in
  let i = li - 1 in
  let n = ri - li + 1 in
  let count = ref 0 in
  for j = 0 to ns - n do
    if is_similar s i j n then incr count
  done;
  !count;;

let pr_similar_strings_data s = (* for debugging *)
  let ns = S.length s
  and {csc; csuftab; csufinv; clcp} = similar_strings_data s in
  let ws = S.make ns ' ' in
  prf "# rank index clcp(rank,rank+1) s[index..]' s[index..]\n";
  for r = 0 to ns - 1 do
    let i = csuftab.(r) in
    prf "%3d %3d %3d '%s'%s '%s'\n" r i
        (if r < ns - 1 then clcp.(r) else -1)
        (canonical s csc i (ns - i)) (S.sub ws 0 i)
        (S.sub s i (ns - i))
  done;;

(* -- I/O and driver -- *)

let main () =
  let n, q = Scanf.scanf "%d %d" (fun n q -> n, q) in
  assert (1 <= n && n <= 50000);
  assert (1 <= q && q <= 50000);
  let s = Scanf.scanf " %s" (fun s -> s) in
  assert (S.length s = n);
  for _ = 1 to q do
    let li, ri = Scanf.scanf " %d %d" (fun li ri -> li, ri) in
    assert (1 <= li && li <= ri && ri <= n);
    prf "%d\n" (similar_strings s li ri)
  done;;

if not !Sys.interactive then main ();;

(*
# generating test data
import random
n = 50000
s = ''.join([chr(random.randint(97, 106)) for _ in range(n)])
with file('tmp', 'w') as f: f.write(s)

# other test vectors
let s1 = "baddadacca"    (* "missisippi" under (imps -> abcd) *)
and s2 = "abeacadabea";; (* "abracadabra" under (r -> e) *)
*)

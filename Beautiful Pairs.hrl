% Enter your code here. Read input from STDIN. Print output to STDOUT
% Your class should be named solution

-module(solution).
-export([main/0]).

read_nums(N) -> {ok, Res} = io:fread("", "~d" ++ lists:concat(["~d" || _ <- lists:seq(2, N)])),
		Res.

main() -> 
    {ok, [N]} = io:fread("", "~d"),
    {List1, List2} = {read_nums(N), read_nums(N)},
    Res1 = List1 -- List2,
    L = length(List1) - length(Res1),
    case (L < length(List1)) andalso (L < length(List2)) of
	true -> io:format("~p~n", [L + 1]);
	false -> case (L == length(List2)) of
		     true -> io:format("~p~n", [L - 1]);
		     false -> io:format("~p~n", [L])
		 end
    end.
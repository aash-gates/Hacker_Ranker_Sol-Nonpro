var     a: array[1..4] of longint;
        ans: int64;
        f: array[0..3000,0..5000] of longint;
        dp: array[0..3000] of longint;
procedure main;
 var    i,j,tm: longint;
 begin
        for i:=1 to 4 do read(a[i]);
        for i:=1 to 4 do
         for j:=i+1 to 4 do
          if a[i]>a[j] then
           begin
                tm:=a[i];
                a[i]:=a[j];
                a[j]:=tm;
           end;
        for i:=1 to a[1] do
         for j:=i to a[2] do inc(f[j,i xor j]);
        for i:=1 to a[2] do
         for j:=0 to 5000 do f[i,j]:=f[i,j]+f[i-1,j];
        for i:=1 to a[2] do
         for j:=0 to 5000 do dp[i]:=dp[i]+f[i,j];
        for i:=1 to a[3] do
         for j:=i to a[4] do
          if i<a[2] then ans:=ans+dp[i]-f[i,i xor j]
          else  ans:=ans+dp[a[2]]-f[a[2],i xor j];
        writeln(ans);
 end;
BEGIN
        main;
END.
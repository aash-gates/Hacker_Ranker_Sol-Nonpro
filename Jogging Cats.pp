var
    ans:int64;
    n,m,i,j,t,u,v,p:longint;
    f:array[0..200005,1..3]of longint;
    l,num,bfs,h,w:array[0..50005]of longint;
    sum:array[0..50005]of int64;
procedure add(x,y:longint);
begin
    inc(p);
    f[p,1]:=y;
    f[p,2]:=l[x];
    f[l[x],3]:=p;
    l[x]:=p;
end;
procedure delpoint(a:longint);
var
    k,kk,x:longint;
begin
    kk:=l[a];
    while kk<>0 do
    begin
        x:=f[kk,1];
        k:=kk xor 1;
        if f[k,3]=0 then
        begin
            l[x]:=f[k,2];
            f[f[k,2],3]:=0;
        end
        else
        begin
            f[f[k,2],3]:=f[k,3];
            f[f[k,3],2]:=f[k,2];
        end;
        dec(num[x]);
        if num[x]=1 then
        begin
            inc(j);bfs[j]:=x;
        end;
        kk:=f[kk,2];
    end;
    num[a]:=0;
    l[a]:=0;
end;
procedure delone;
var
    k,x:longint;
begin
    while i<>j do
    begin
        inc(i);
        if num[bfs[i]]=0 then continue;
        dec(num[bfs[i]]);
        k:=l[bfs[i]];
        l[bfs[i]]:=0;
        x:=f[k,1];
        k:=k xor 1;
        if f[k,3]=0 then
        begin
            l[x]:=f[k,2];
            f[f[k,2],3]:=0;
        end
        else
        begin
            f[f[k,2],3]:=f[k,3];
            f[f[k,3],2]:=f[k,2];
        end;
        dec(num[x]);
        if num[x]=1 then
        begin
            inc(j);bfs[j]:=x;
        end;
    end;
end;
procedure work(x:longint);
var
    k,kk,i,j:longint;
begin
    k:=l[x];
    while k<>0 do
    begin
        kk:=l[f[k,1]];
        while kk<>0 do
        begin
            ans:=ans+sum[f[kk,1]];
            inc(sum[f[kk,1]]);
            kk:=f[kk,2];
        end;
        k:=f[k,2];
    end;
    ans:=ans-(sum[x]*(sum[x]-1)div 2);
    k:=l[x];
    while k<>0 do
    begin
        kk:=l[f[k,1]];
        while kk<>0 do
        begin
            sum[f[kk,1]]:=0;
            kk:=f[kk,2];
        end;
        k:=f[k,2];
    end;
end;
procedure qsort(i,j:longint);
var
    l,r,m:longint;
begin
    l:=i;r:=j;m:=h[(i+j)div 2];
    repeat
        while h[i]>m do inc(i);
        while h[j]<m do dec(j);
        if i<=j then
        begin
            h[0]:=h[i];h[i]:=h[j];h[j]:=h[0];
            w[0]:=w[i];w[i]:=w[j];w[j]:=w[0];
            inc(i);dec(j);
        end;
    until i>j;
    if i<r then qsort(i,r);
    if l<j then qsort(l,j);
end;
begin
    readln(n,m);
    p:=1;
    begin
        add(u,v);add(v,u);
    end;
    j:=0;
    begin
        inc(j);bfs[j]:=i;
    i:=0;
    for t:=1 to n do h[t]:=num[t];
    qsort(1,n);
    begin
        if num[w[t]]<>0 then
    end;
    writeln(ans);
end.
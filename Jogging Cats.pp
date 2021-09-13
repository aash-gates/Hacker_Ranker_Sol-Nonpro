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

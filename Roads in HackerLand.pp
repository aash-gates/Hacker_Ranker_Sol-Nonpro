var i,j,n,m,u,v,t,vt:longint;
        gt:int64;
        d,head,per,link,kt,a,b,c,aa:array[0..1000000] of longint;
        sl,bit:array[0..10000000] of int64;
procedure them(x,y,c:longint);
begin
        inc(t);

        aa[t]:=y;
        d[t]:=c;

        link[t]:=head[x];
        head[x]:=t;
end;
procedure swap(var a,b:longint);
var c:longint;
begin
        c:=a;a:=b;b:=c;
end;
procedure sort(l,r:longint);
var i,j,x,y:longint;
begin
        i:=l;
        j:=r;
        x:=c[(i+j) div 2];
        repeat
                while c[i]<x do inc(i);
                while c[j]>x do dec(j);
                if not (i>j) then
                begin
                        swap(a[i],a[j]);
                        swap(b[i],b[j]);
                        swap(c[i],c[j]);
                        inc(i);
                        dec(j);
                end;
        until i>j;
        if i<r then sort(i,r);
        if j>l then sort(l,j);
end;
procedure dfs(u:longint);
var i:longint;
begin
        kt[u]:=1;
        sl[u]:=1;
        i:=head[u];
       // writeln(u);
        while i>0 do
        begin
                if kt[aa[i]]=0 then
                begin
                        dfs(aa[i]);
                      //  writeln(u,' ',aa[i],' ',d[i]);
                        sl[u]:=sl[u]+sl[aa[i]];
                        bit[d[i]]:=(n-sl[aa[i]])*sl[aa[i]];
                end;
                i:=link[i];
        end;
end;
function goc(x:longint):longint;
begin
        while per[x]<>x do x:=per[x];
        exit(x);
end;
begin
        readln(n,m);
        for i:=1 to n do per[i]:=i;
        for i:=1 to  m do
        begin
                readln(a[i],b[i],c[i]);
        end;
        sort(1,m);
        for i:=1 to m do
        begin
                u:=goc(a[i]);
                v:=goc(b[i]);
                if u<>v then
                begin
                        them(a[i],b[i],c[i]);
                        them(b[i],a[i],c[i]);
                        per[u]:=v;
                        per[a[i]]:=v;
                        per[b[i]]:=v;
                      //  writeln(a[i],' ',b[i]);
                end;
        end;
        dfs(1);
        for i:=0 to 1000000 do
        begin
       //         if bit[i]<>0 then writeln(i,' ',bit[i]);
                gt:=gt+bit[i];
                bit[i]:=gt mod 2;
                gt:=gt div 2;
                if bit[i]=1 then vt:=i;
        end;
        for i:=vt downto 0 do write(bit[i]);
end.

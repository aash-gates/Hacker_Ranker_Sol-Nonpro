uses math;
const
    tfi='';
    tfo='';
var
    n,test,i,j:longint;
    m,res,res1,g:int64;
    s,a,pos,t:array[0..200000] of int64;
procedure inp;
    var
        i:longint;
    begin
        readln(n,m);
        for i:= 1 to n do read(a[i]);
        for i:= 1 to n do a[i]:=a[i] mod m;
        s[0]:=0;
        for i:= 1 to n do s[i]:=(s[i-1]+a[i]) mod m;
        for i:= 0 to n do pos[i]:=i;
    end;
procedure swap(var i,j:int64);
    var
        tg:int64;
    begin
        tg:=i;i:=j;j:=tg;
    end;
procedure qs(l,r:longint);
    var
        i,j,mid:longint;
        key:int64;
    begin
        i:=l;j:=r;mid:=l+random(r-l+1);
        key:=s[mid];
        repeat
            while s[i]<key do inc(i);
            while s[j]>key do dec(j);
            if i<=j then
                begin
                    swap(s[i],s[j]);
                    swap(pos[i],pos[j]);
                    inc(i);dec(j);
                end;
        until i>j;
        if l<j then qs(l,j);
        if i<r then qs(i,r);
    end;
procedure update(i:longint;x:int64);
    begin
        while i<=n+1 do
            begin
                t[i]:=min(t[i],x);
                inc(i,i and (-i));
            end;
    end;
function get(i:longint):int64;
    begin
        get:=m+1;
        while i>0 do
            begin
                if t[i]<>g then
                get:=min(get,t[i]);
                dec(i,i and (-i));
            end;
    end;
procedure process;
    var
        i,j:longint;
        x:int64;
    begin
        for i:= 1 to n+ 1 do t[i]:=m+1;
        res:=0;
        qs(0,n);
        for i:= 0 to n do inc(pos[i]);
        for i:= 0 to n do res:=max(res,s[i]);
        for i:= n downto 0 do
            begin
                g:=s[i];
                x:=get(pos[i]-1);
                if x<>m+1 then res:=max(res,(s[i]-x+m) mod m);
                update(pos[i],s[i]);
            end;

        writeln(res);
    end;
begin
    assign(input,tfi);reset(input);
    assign(output,tfo);rewrite(output);
    read(test);
      for i:= 1 to test do
        begin
            inp;
            process;
        end;
    close(input);close(output);
end.



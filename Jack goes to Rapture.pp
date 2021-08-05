uses math;
const
    tfi='';
    tfo='';
    oo=2000000000;
var
    adj,prev,ts:array[-500000..500000] of longint;
    head,pos,h:array[1..50000] of longint;
    n,m,nh:longint;
    d:array[1..50000] of int64;
    free:array[1..50000] of boolean;
procedure add(i,u,v,c:longint);
    begin
        adj[i]:=v;adj[-i]:=u;
        prev[i]:=head[u];prev[-i]:=head[v];
        head[u]:=i;head[v]:=-i;
        ts[i]:=c;ts[-i]:=c;
    end;
procedure inp;
    var
        i,u,v,c:longint;
    begin
        read(n,m);
        for i:= 1 to m do
            begin
                read(u,v,c);
                add(i,u,v,c);
            end;
    end;
procedure swap(var i,j:longint);
    var
        tg:longint;
    begin
        tg:=i;i:=j;j:=tg;
    end;
procedure upheap(i:longint);
    begin
        if (i=1) or (d[h[i]]>=d[h[i div 2]]) then exit;
        swap(h[i],h[i div 2]);
        swap(pos[h[i]],pos[h[i div 2]]);
        upheap(i div 2);
    end;
procedure push(x:longint);
    begin
        inc(nh);
        h[nh]:=x;
        pos[x]:=nh;
        upheap(nh);
    end;
procedure downheap(i:longint);
    var
        j:longint;
    begin
        j:=i*2;
        if j>nh then exit;
        if (j<nh) and (d[h[j]]>d[h[j+1]]) then inc(j);
        if d[h[i]]>d[h[j]] then
            begin
                swap(h[i],h[j]);
                swap(pos[h[i]],pos[h[j]]);
                downheap(j);
            end;
    end;
function pop:longint;
    begin
        pop:=h[1];
        h[1]:=h[nh];
        pos[h[1]]:=1;
        dec(nh); 
        downheap(1);
    end;
procedure dij;
    var
        u,j,v,i:longint;
    begin
        nh:=0;
        for i:= 1 to n do d[i]:=oo;
        d[1]:=0;
        push(1);
        repeat
            u:=pop;
            if u=n then exit;
            free[u]:=true;
            j:=head[u];
            while j<>0 do
                begin
                    v:=adj[j];
                    if not free[v] and (d[v]>d[u]+max(0,ts[j]-d[u])) then
                        begin
                            d[v]:=d[u]+max(0,ts[j]-d[u]);
                            if pos[v]=0 then push(v)
                            else upheap(pos[v]);
                        end;
                    j:=prev[j];
                end;
        until nh=0;
    end;
procedure process;
    begin
        dij;
        if d[n]= oo then writeln('NO PATH EXISTS') else
        writeln(d[n]);
    end;
begin
    assign(input,tfi);reset(input);
    assign(output,tfo);rewrite(output);
    inp;
    process;
    close(input);close(output);
end.


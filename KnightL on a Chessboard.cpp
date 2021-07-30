#include<bits/stdc++.h>
using namespace std;
bool in(int x,int y,int n)
{
    if(x<n&&y<n&&x>=0&&y>=0)
        return 1;
    return 0;
}
int func(int a,int b,int n)
{
   bool visited[35][35]={{0}};
   int d[35][35];
   int dx[8]={a,a,-a,-a,b,b,-b,-b};
   int dy[8]={b,-b,b,-b,a,-a,a,-a};
   queue<pair<int,int> > q;
   d[0][0]=0;
   q.push(make_pair(0,0));
   visited[0][0]=1;
   while(!q.empty())
   {
       pair<int,int> p=q.front();
       int x=p.first;
       int y=p.second;
       q.pop();
       for(int i=0;i<8;i++)
       {
           if(in(x+dx[i],y+dy[i],n))
           {
               if(!visited[x+dx[i]][y+dy[i]])
               {d[x+dx[i]][y+dy[i]]=d[x][y]+1;
               visited[x+dx[i]][y+dy[i]]=1;
               q.push(make_pair(x+dx[i],y+dy[i]));
               }
           }
       }
   }
   if(!visited[n-1][n-1])
   {
       return -1;
   }
   return d[n-1][n-1];
}
int main()
{
    int n,i,j,k;
    cin>>n;
    for(i=1;i<n;i++)
    {
        for(j=1;j<n;j++)
        {
            cout<<func(i,j,n)<<" ";
        }
        cout<<endl;
    }
    return 0;
}

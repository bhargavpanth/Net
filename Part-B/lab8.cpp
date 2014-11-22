using namespace std;
#include<iostream>
#include<stdio.h>
int min(int x,int y)
{
return(x<y)?x:y;
}
int main()
{
int a[20][20];
int n,i,j,k;
cout<<"eneter no of nodes\n";
cin>>n;
cout<<"enetr cost adjacency matrix\n";
for(i=1;i<=n;i++)
for(j=1;j<=n;j++)
cin>>a[i][j];
for(k=1;k<=n;k++)
for(i=1;i<=n;i++)
for(j=1;j<=n;j++)
{
a[i][j]=min(a[i][j],a[i][k]+a[k][j]);
}
cout<<"enter the node you want to check\n";
cin>>i;
for(j=1;j<=n;j++)
cout<<"cost from"<<i<<"to"<<j<<"is"<<a[i][j]<<endl;
}

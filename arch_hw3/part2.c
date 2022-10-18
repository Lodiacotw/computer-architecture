#include <stdio.h>

int fib(int x){
	if(x == 0) return 0;
	else if(x == 1) return 1;
	else{
		return (fib(x-1)+fib(x-2));
	}
}

int re(int x,int y){
	if(y <= 0) return 0;
	else if(x <= 0)	return 1;
	else return re(x,y-2)+re(x-5,y);
}

int main(){
	int x,y,z,ans;
	printf("input x: ");
	scanf("%d",&x);
	printf("input y: ");
	scanf("%d",&y);
	ans = re(fib(x),y);
	printf("result = %d\n",ans);
	return 0;
}

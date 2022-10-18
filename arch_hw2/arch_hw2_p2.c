#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

	srand(time(NULL));
	int ans; //the answer that randomly generate
	int guess;	//your guess in every round
	int round=0;
	int min=0,max;	//the range [0,max]

	//enter the range
	printf("Please enter the range\n");
	scanf("%d",&max);
	printf("The range is 0 to %d \n",max);
	//randomly generate a answer
	ans = rand()%(max+1);

	//player has 5 rounds to guess
	while(round < 5){

		//start to guess	
		printf("Round %d start...\n", round+1);
		printf("Please guess a number:\n");

		//enter the guess and check the validation of the guess 
		while(1){
			scanf("%d",&guess);
			//check the input, if it is a incorrect input, ask the player to retry
			if(guess>max || guess<min)  printf("You are out of range! Guess again!\n");
			else break;
		}
		//Win! You get the correct answer
		if(guess == ans){
			printf("You win!\n");
			break;
		}
		//update the min or max to narrow the range to guess
		else if(guess < ans) min = guess+1;
		else if(guess > ans) max = guess-1;	//guess bigger than min
	
		//You only have five round to guess
		//if you don't get the right answer,enter the next round
		if(round < 4){
			printf("You should guess from %d to %d\n",min,max);
			round++;
		}
		//if you can't get the answer in 5 times, the program will stop
		else{ 
			printf("You lose haha! The answer is %d\n",ans);
			break;
		}
	}
	
	return 0;
}

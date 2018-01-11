#include <stdio.h>

#define MAXN 10

int N;
int A[MAXN][MAXN], B[MAXN][MAXN], C[MAXN][MAXN];

int main()
{
	scanf("%d", &N);
	for(int i=0; i<N; i++)
		for(int j=0; j<N; j++)
			scanf("%d", &A[i][j]);
	for(int i=0; i<N; i++)
		for(int j=0; j<N; j++)
			scanf("%d", &B[i][j]);
	for(int i=0; i<N; i++)
	{
		for(int j=0; j<N; j++)
		{
			for(int k=0; k<N; k++)
				C[i][j] += A[i][k] * B[k][j];
			printf("%d ", C[i][j]);
		}
		printf("\n");
	}
}
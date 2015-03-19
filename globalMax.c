#include <stdio.h>
#include <assert.h>

int main(int argc, char*argv[])
{
    int N = atoi(argv[1]);
    assert(N>0 && N<=10000000);
    int *a;
	int size = N * sizeof( int );

	a = (int *)malloc( size );
    int cpu_max = 0;

	for( int i = 0; i < N; i++ )
	{
		a[i] = i;
	}

    for (int i = 0; i < N; i++)
    {
        if (cpu_max < a[i])
            cpu_max = a[i];
    }

	printf( "global max = %d\n", cpu_max);

	/* clean up */

	free(a);
	
	return 0;
} /* end main */

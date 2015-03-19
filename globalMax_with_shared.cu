#include <stdio.h>
#include <assert.h>

__global__ void globalMax(int *a, int N, int* gl_max)
{
    /* insert code to calculate the index properly using blockIdx.x, blockDim.x, threadIdx.x */
	int index = blockIdx.x * blockDim.x + threadIdx.x;
    if (index < N) 
    {
      int val = a[index];
      __shared__ int subMax;
      
      if (threadIdx.x == 0)
          subMax = 0;
      __syncthreads();     

      atomicMax(&subMax, val);
      __syncthreads();
     
      if (threadIdx.x == 0)  
	    atomicMax(gl_max, subMax);
    }
}

#define THREADS_PER_BLOCK 512

int main(int argc, char*argv[])
{
    int N = atoi(argv[1]);
    //assert(N>0 && N<=1000000);
    int *a;
	int *d_a;
    int *d_max;
	int size = N * sizeof( int );

	/* allocate space for device copies of a, max */

	cudaMalloc( (void **) &d_a, size );
	cudaMalloc( (void **) &d_max, sizeof(int) );


	/* allocate space for host copies of a, cpu_max, and setup input values */

	a = (int *)malloc( size );
    int cpu_max = 0;

	for( int i = 0; i < N; i++ )
	{
		a[i] = i;
	}

	/* copy inputs to device */
	/* fix the parameters needed to copy data to the device */
	cudaMemcpy( d_a, a, size, cudaMemcpyHostToDevice );
	cudaMemcpy( d_max, &cpu_max, sizeof(int), cudaMemcpyHostToDevice );


	/* launch the kernel on the GPU */
	/* insert the launch parameters to launch the kernel properly using blocks and threads */ 
	globalMax<<< (N + (THREADS_PER_BLOCK-1)) / THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( d_a, N, d_max);


	/* copy result back to host */
	/* fix the parameters needed to copy data back to the host */
	cudaMemcpy( &cpu_max, d_max, sizeof(int), cudaMemcpyDeviceToHost );


	printf( "global max = %d\n", cpu_max);

	/* clean up */

	free(a);
	cudaFree( d_a );
	cudaFree( d_max );
	
	return 0;
} /* end main */

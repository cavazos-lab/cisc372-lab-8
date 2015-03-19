globalMax:
	nvcc -arch=sm_13 globalMax.cu -o globalMax
shared:
	nvcc -arch=sm_13 globalMax_with_shared.cu -o globalMax_with_shared
seq:
	gcc -std=c99 globalMax.c -o globalMax-seq

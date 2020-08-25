ptxas -arch=sm_70 -m64  "generation.ptx"  -o "generation.sm_70.cubin" 
fatbinary --create="generation.fatbin" -64 "--image=profile=sm_70,file=generation.sm_70.cubin" "--image=profile=compute_70,file=generation.ptx" --embedded-fatbin="generation.fatbin.c" 
gcc -E -x c++ -D__CUDACC__ -D__NVCC__  -O3 -I"/home/tgrogers-raid/a/aalawneh/../common/NVIDIA_GPU_Computing_SDK/10.1/../4.2/C/common/inc" -I"/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/include" "-I/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//include"    -D__CUDACC_VER_MAJOR__=10 -D__CUDACC_VER_MINOR__=1 -D__CUDACC_VER_BUILD__=168 -include "cuda_runtime.h" -m64 "generation.cu" > "generation.cpp4.ii" 
cudafe++ --c++14 --gnu_version=70500 --allow_managed  --m64 --parse_templates --gen_c_file_name "generation.cudafe1.cpp" --stub_file_name "generation.cudafe1.stub.c" --module_id_file_name "generation.module_id" "generation.cpp4.ii" 
gcc -D__CUDA_ARCH__=700 -c -x c++  -DCUDA_DOUBLE_MATH_FUNCTIONS -O3 -I"/home/tgrogers-raid/a/aalawneh/../common/NVIDIA_GPU_Computing_SDK/10.1/../4.2/C/common/inc" -I"/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/include" "-I/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//include"   -m64 -o "generation.o" "generation.cudafe1.cpp" 
nvlink --arch=sm_70 --register-link-binaries="generationV_TP_dlink.reg.c"  -m64 -L"/home/tgrogers-raid/a/aalawneh/../common/NVIDIA_GPU_Computing_SDK/10.1/../4.2/C/lib" -lcutil_x86_64 -lcudart   "-L/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//lib64/stubs" "-L/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//lib64" -cpu-arch=X86_64 "dataset_loader.o" "generation.o"  -lcudadevrt  -o "generationV_TP_dlink.sm_70.cubin"
fatbinary --create="generationV_TP_dlink.fatbin" -64 -link "--image=profile=sm_70,file=generationV_TP_dlink.sm_70.cubin" --embedded-fatbin="generationV_TP_dlink.fatbin.c" 
gcc -c -x c++ -DFATBINFILE="\"generationV_TP_dlink.fatbin.c\"" -DREGISTERLINKBINARYFILE="\"generationV_TP_dlink.reg.c\"" -I. -D__NV_EXTRA_INITIALIZATION= -D__NV_EXTRA_FINALIZATION= -D__CUDA_INCLUDE_COMPILER_INTERNAL_HEADERS__  -O3 -I"/home/tgrogers-raid/a/aalawneh/../common/NVIDIA_GPU_Computing_SDK/10.1/../4.2/C/common/inc" -I"/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/include" "-I/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//include"    -D__CUDACC_VER_MAJOR__=10 -D__CUDACC_VER_MINOR__=1 -D__CUDACC_VER_BUILD__=168 -m64 -o "generationV_TP_dlink.o" "/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/crt/link.stub" 
g++ -O3 -m64 -o "/home/tgrogers-raid/a/aalawneh/gpgpu-sim_simulations_chucnk/benchmarks/src/../bin/10.1/release/generationV_TP" -Wl,--start-group "generationV_TP_dlink.o" "dataset_loader.o" "generation.o" -L"/home/tgrogers-raid/a/aalawneh/../common/NVIDIA_GPU_Computing_SDK/10.1/../4.2/C/lib" -lcutil_x86_64 -lcudart   "-L/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//lib64/stubs" "-L/home/tgrogers-raid/a/aalawneh/../common/cuda-10.1/bin/..//lib64" -lcudadevrt  -lcudart_static  -lrt -lpthread  -ldl  -Wl,--end-group 
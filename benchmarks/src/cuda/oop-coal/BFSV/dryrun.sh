ptxas -arch=sm_70 -m64  "bfs.ptx"  -o "bfs.sm_70.cubin" 
fatbinary --create="bfs.fatbin" -64 "--image=profile=sm_70,file=bfs.sm_70.cubin" "--image=profile=compute_70,file=bfs.ptx" --embedded-fatbin="bfs.fatbin.c" --cuda
gcc -std=c++14 -E -x c++ -D__CUDACC__ -D__NVCC__  -O3 -I"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/common/inc" -I"/usr/local/cuda-9.1/include" "-I/usr/local/cuda-9.1/bin/..//include"   -D"__CUDACC_VER_BUILD__=85" -D"__CUDACC_VER_MINOR__=1" -D"__CUDACC_VER_MAJOR__=9" -include "cuda_runtime.h" -m64 "bfs.cu" > "bfs.cpp4.ii" 
cudafe++ --c++14 --gnu_version=60500 --allow_managed  --m64 --parse_templates --gen_c_file_name "bfs.cudafe1.cpp" --stub_file_name "bfs.cudafe1.stub.c" --module_id_file_name "bfs.module_id" "bfs.cpp4.ii" 
gcc -std=c++14 -D__CUDA_ARCH__=700 -c -x c++  -DCUDA_DOUBLE_MATH_FUNCTIONS -O3 -I"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/common/inc" -I"/usr/local/cuda-9.1/include" "-I/usr/local/cuda-9.1/bin/..//include"   -m64 -o "bfs.o" "bfs.cudafe1.cpp" 
nvlink --arch=sm_70 --register-link-binaries="BFSV_COAL_dlink.reg.c"  -m64 -L"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/lib" -lcutil_x86_64 -lcudart   "-L/usr/local/cuda-9.1/bin/..//lib64/stubs" "-L/usr/local/cuda-9.1/bin/..//lib64" -cpu-arch=X86_64 "bfs.o" "parse.o" "util.o"  -lcudadevrt  -o "BFSV_COAL_dlink.sm_70.cubin"
fatbinary --create="BFSV_COAL_dlink.fatbin" -64 -link "--image=profile=sm_70,file=BFSV_COAL_dlink.sm_70.cubin" --embedded-fatbin="BFSV_COAL_dlink.fatbin.c" 
gcc -std=c++14 -c -x c++ -DFATBINFILE="\"BFSV_COAL_dlink.fatbin.c\"" -DREGISTERLINKBINARYFILE="\"BFSV_COAL_dlink.reg.c\"" -I. -D__NV_EXTRA_INITIALIZATION= -D__NV_EXTRA_FINALIZATION=  -O3 -I"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/common/inc" -I"/usr/local/cuda-9.1/include" "-I/usr/local/cuda-9.1/bin/..//include"   -D"__CUDACC_VER_BUILD__=85" -D"__CUDACC_VER_MINOR__=1" -D"__CUDACC_VER_MAJOR__=9" -m64 -o "BFSV_COAL_dlink.o" "/usr/local/cuda-9.1/bin/crt/link.stub" 
g++ -O3 -m64 -o "/home/aalawneh/oomalloc/gpgpu-sim/gpgpu-sim_simulations/benchmarks/src/../bin/9.1/release/BFSV_COAL" -std=c++14 -Wl,--start-group "BFSV_COAL_dlink.o" "bfs.o" "parse.o" "util.o" -L"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/lib" -lcutil_x86_64 -lcudart   "-L/usr/local/cuda-9.1/bin/..//lib64/stubs" "-L/usr/local/cuda-9.1/bin/..//lib64" -lcudadevrt  -lcudart_static  -lrt -lpthread  -ldl  -Wl,--end-group 
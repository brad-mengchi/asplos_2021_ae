ptxas -arch=sm_70 -m64  "nbody.ptx"  -o "nbody.sm_70.cubin" 
fatbinary --create="nbody.fatbin" -64 "--image=profile=sm_70,file=nbody.sm_70.cubin" "--image=profile=compute_70,file=nbody.ptx" --embedded-fatbin="nbody.fatbin.c" --cuda
gcc -std=c++14 -E -x c++ -D__CUDACC__ -D__NVCC__  -O3 -I"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/common/inc" -I"/usr/local/cuda-9.1/include" "-I/usr/local/cuda-9.1/bin/..//include"   -D"__CUDACC_VER_BUILD__=85" -D"__CUDACC_VER_MINOR__=1" -D"__CUDACC_VER_MAJOR__=9" -include "cuda_runtime.h" -m64 "nbody.cu" > "nbody.cpp4.ii" 
cudafe++ --c++14 --gnu_version=60500 --allow_managed  --m64 --parse_templates --gen_c_file_name "nbody.cudafe1.cpp" --stub_file_name "nbody.cudafe1.stub.c" --module_id_file_name "nbody.module_id" "nbody.cpp4.ii" 
gcc -std=c++14 -D__CUDA_ARCH__=700 -c -x c++  -DCUDA_DOUBLE_MATH_FUNCTIONS -O3 -I"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/common/inc" -I"/usr/local/cuda-9.1/include" "-I/usr/local/cuda-9.1/bin/..//include"   -m64 -o "nbody.o" "nbody.cudafe1.cpp" 
nvlink --arch=sm_70 --register-link-binaries="nbodyV_dlink.reg.c"  -m64 -L"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/lib" -lcutil_x86_64 -lcudart   "-L/usr/local/cuda-9.1/bin/..//lib64/stubs" "-L/usr/local/cuda-9.1/bin/..//lib64" -cpu-arch=X86_64 "nbody.o"  -lcudadevrt  -o "nbodyV_dlink.sm_70.cubin"
fatbinary --create="nbodyV_dlink.fatbin" -64 -link "--image=profile=sm_70,file=nbodyV_dlink.sm_70.cubin" --embedded-fatbin="nbodyV_dlink.fatbin.c" 
gcc -std=c++14 -c -x c++ -DFATBINFILE="\"nbodyV_dlink.fatbin.c\"" -DREGISTERLINKBINARYFILE="\"nbodyV_dlink.reg.c\"" -I. -D__NV_EXTRA_INITIALIZATION= -D__NV_EXTRA_FINALIZATION=  -O3 -I"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/common/inc" -I"/usr/local/cuda-9.1/include" "-I/usr/local/cuda-9.1/bin/..//include"   -D"__CUDACC_VER_BUILD__=85" -D"__CUDACC_VER_MINOR__=1" -D"__CUDACC_VER_MAJOR__=9" -m64 -o "nbodyV_dlink.o" "/usr/local/cuda-9.1/bin/crt/link.stub" 
g++ -O3 -m64 -o "../../../../../bin/9.1/release/nbodyV_COAL" -std=c++14 -Wl,--start-group "nbodyV_dlink.o" "nbody.o" -L"/usr/local/NVIDIA_GPU_Computing_SDK/9.1/../4.2/C/lib" -lcutil_x86_64 -lcudart   "-L/usr/local/cuda-9.1/bin/..//lib64/stubs" "-L/usr/local/cuda-9.1/bin/..//lib64" -lcudadevrt  -lcudart_static  -lrt -lpthread  -ldl  -Wl,--end-group 




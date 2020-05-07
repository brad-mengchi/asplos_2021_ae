start=`date +%s`
DATE=`date '+%Y-%m-%d--%H.%M.%S'`
#ARNAME=turing.rtx2060.cycle.tgz
#TARNAME=quadro.v100.cycle.tgz
#sudo nvidia-smi -i 1 -lgc 1132,1132
#./run_hw.py -D 0 -B `cat ../job_launching/apps/correlation-apps.list` -R 10 -c
#./run_hw.py -D 0 -B Deepbench_nvidia -R 10
#./run_hw.py -D 0 -B GPU_Microbenchmark,Deepbench_nvidia,sdk-4.2-scaled,rodinia-3.1,parboil,polybench,cutlass_5_trace -R 5 -N -d
#./run_hw.py -D 0 -B cutlass_5 -R 10 -c
#sudo nvidia-smi -i 1 -rgc
#find ../../run_hw/ -name "*.out*" -exec rm {} \;
#find ../../run_hw/ -type f -name "*output*" -exec rm {} \;
#find ../../run_hw/ -type f -name "*reference.dat*" -exec rm {} \;
#find ../../run_hw/ -type f -name "*result.txt*" -exec rm {} \;
#cp -r ../../run_hw/device-0 ../../run_hw/TURING-RTX2060
#cd ../../run_hw
#tar zcvf $TARNAME ./TURING-RTX2060
#ssh dynamo.ecn.purdue.edu mv /home/dynamo/a/tgrogers/website/gpgpu-sim/hw_data/$TARNAME /home/dynamo/a/tgrogers/website/gpgpu-sim/hw_data/bak.$DATE.$TARNAME
#scp $TARNAME dynamo.ecn.purdue.edu:~/website/gpgpu-sim/hw_data/

TARNAME=kepler.titan.cycle.tgz
#TARNAME=quadro.v100.cycle.tgz
#sudo nvidia-smi -i 1 -lgc 1132,1132
#./run_hw.py -D 0 -B `cat ../job_launching/apps/correlation-apps.list` -R 10 -c
#./run_hw.py -D 0 -B Deepbench_nvidia -R 10
./run_hw.py -D 1 -B GPU_Microbenchmark,Deepbench_nvidia,sdk-4.2-scaled,rodinia-3.1,parboil,polybench,cutlass_5_trace -R 5
#./run_hw.py -D 0 -B cutlass_5 -R 10 -c
#sudo nvidia-smi -i 1 -rgc
find ../../run_hw/ -name "*.out*" -exec rm {} \;
find ../../run_hw/ -type f -name "*output*" -exec rm {} \;
find ../../run_hw/ -type f -name "*reference.dat*" -exec rm {} \;
find ../../run_hw/ -type f -name "*result.txt*" -exec rm {} \;
cp -r ../../run_hw/device-1 ../../run_hw/KEPLER-TITAN
cd ../../run_hw
tar zcvf $TARNAME ./KEPLER-TITAN
ssh dynamo.ecn.purdue.edu mv /home/dynamo/a/tgrogers/website/gpgpu-sim/hw_data/$TARNAME /home/dynamo/a/tgrogers/website/gpgpu-sim/hw_data/bak.$DATE.$TARNAME
scp $TARNAME dynamo.ecn.purdue.edu:~/website/gpgpu-sim/hw_data/
end=`date +%s`
runtime=$((end-start))
echo "Runtime: $runtime"

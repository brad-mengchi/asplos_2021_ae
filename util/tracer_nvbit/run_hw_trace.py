#!/usr/bin/env python

from optparse import OptionParser
import os
import subprocess
import os
this_directory = os.path.dirname(os.path.realpath(__file__)) + "/"
import sys
sys.path.insert(0,os.path.join(this_directory,"..","job_launching"))
import common
import re
import shutil
import glob
import datetime
import yaml
import common
import re
import datetime

# We will look for the benchmarks
parser = OptionParser()
parser.add_option("-B", "--benchmark_list", dest="benchmark_list",
                 help="a comma seperated list of benchmark suites to run. See apps/define-*.yml for " +\
                       "the benchmark suite names.",
                 default="rodinia_2.0-ft")
parser.add_option("-D", "--device_num", dest="device_num",
                 help="CUDA device number",
                 default="0")
parser.add_option("-n", "--norun", dest="norun", action="store_true",
                 help="Do not actually run the apps, just create the dir structure and launch files")

(options, args) = parser.parse_args()

common.load_defined_yamls()

benchmarks = []
benchmarks = common.gen_apps_from_suite_list(options.benchmark_list.split(","))

cuda_version = common.get_cuda_version( this_directory )
now_time = datetime.datetime.now()
day_string = now_time.strftime("%y.%m.%d-%A")
time_string = now_time.strftime("%H:%M:%S")
logfile = day_string + "--" + time_string + ".csv"

nvbit_tracer_path = os.path.join(this_directory, "tracer_tool")

for bench in benchmarks:
    edir, ddir, exe, argslist = bench
    ddir = os.path.join(this_directory,ddir,exe)
    for args in argslist:
        run_name = os.path.join( exe, common.get_argfoldername( args ) )

        this_run_dir = os.path.join(this_directory, "..", "..", "run_hw","traces","device-" + options.device_num, cuda_version, run_name)
        if not os.path.exists(this_run_dir):
            os.makedirs(this_run_dir)

        print ddir
        # link the data directory
        if os.path.isdir(os.path.join(ddir, "data")):
            if os.path.lexists(os.path.join(this_run_dir, "data")):
                os.remove(os.path.join(this_run_dir, "data"))
            print os.path.join(ddir, "data")
            os.symlink(os.path.join(ddir, "data"), os.path.join(this_run_dir,"data"))

        if args == None:
            args = ""

        sh_contents = ""

	# first we generate the traces (.trace and kernelslist files)
	# then, we do post-processing for the traces and generate (.traceg and kernelslist.g files)
	# then, we delete the intermediate files ((.trace and kernelslist files files)
        sh_contents += "\nexport CUDA_VERSION=\"" + cuda_version + "\"; export CUDA_VISIBLE_DEVICES=\"" + options.device_num + "\" ; " +\
            "LD_PRELOAD=" + os.path.join(nvbit_tracer_path, "tracer_tool.so") + " " + os.path.join(this_directory, edir,exe) +\
            " " + str(args) + " ; " + os.path.join(nvbit_tracer_path,"traces-processing", "post-traces-processing") + " " +\
            os.path.join(this_run_dir, "traces", "kernelslist") + " ; rm " + os.path.join(this_run_dir, "traces") + "/*.trace "

        print ("sh_contents: ", sh_contents)
        print ("this_run_dir: ", this_run_dir)
        print ("this_dir", this_directory)

        open(os.path.join(this_run_dir,"run.sh"), "w").write(sh_contents)
        if subprocess.call(['chmod', 'u+x', os.path.join(this_run_dir,"run.sh")]) != 0:
            exit("Error chmod runfile")

        if not options.norun:
            saved_dir = os.getcwd()
            os.chdir(this_run_dir)
            print "Running {0}".format(exe)

            if subprocess.call(["bash", "run.sh"]) != 0:
                print "Error invoking nvbit on {0}".format(this_run_dir)
            os.chdir(saved_dir)

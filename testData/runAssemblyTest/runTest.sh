#!/usr/bin/env bash
set -e
rootdir=$( cd $(dirname $0) ; pwd -P )

if [ -z ${EDGE_HOME+x} ]; then
	EDGE_HOME="$rootdir/../../"
fi

test_result(){
	Test=$rootdir/TestOutput/AssemblyBasedAnalysis/contigs.fa
	testName="EDGE Reads Assembly test";
	if [ -s $Test ]
	then
		grep -c ">" $Test | awk '{print "Contigs number: " $1}'
		echo "$testName finished"
		touch "$rootdir/TestOutput/test.success"
	else
		echo "$testName failed!"
		touch "$rootdir/TestOutput/test.fail"
	fi
}

cd $rootdir
echo "Working Dir: $rootdir";
echo "EDGE HOME Dir: $EDGE_HOME";

if [ ! -f "$rootdir/TestOutput/test.success" ]
then
	rm -rf $rootdir/TestOutput
fi

perl $EDGE_HOME/runPipeline -c $rootdir/config.txt -o $rootdir/TestOutput -cpu 4 -noColorLog  -p $rootdir/../Ecoli_10x.1.fastq $rootdir/../Ecoli_10x.2.fastq || true

rm -rf $rootdir/TestOutput/QcReads

test_result;

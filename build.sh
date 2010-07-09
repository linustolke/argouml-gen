#!/bin/sh

# TODO: The Cobertura setup depends on things from the JCoverage setup.
JCOVERAGE_ADDS="-lib tools/jcoverage -lib tools/jcoverage-1.0.5/lib/junit/3.8.1 -lib tools/jcoverage-1.0.5 -lib tools/jcoverage-1.0.5/lib/bcel/5.1 -lib tools/jcoverage-1.0.5/lib/gnu/getopt/1.0.9 -lib tools/jcoverage-1.0.5/lib/log4j/1.2.8 -lib tools/jcoverage-1.0.5/lib/oro/2.0.7"
COBERTURA_ADDS="-lib tools/cobertura-1.8 -lib tools/cobertura-1.8/lib"

tools/apache-ant-1.8.1/bin/ant \
    -lib tools/findbugs-0.7.4/lib \
    -lib tools/jdepend-2.6/lib \
    $COBERTURA_ADDS \
    $JCOVERAGE_ADDS \
    "$@"

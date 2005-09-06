#!/bin/sh
chmod +x tools/apache-ant-1.6.1/bin/ant
tools/apache-ant-1.6.1/bin/ant -lib tools/checkstyle-3.3 -lib tools/findbugs-0.7.4/lib -lib tools/jdepend-2.6/lib -lib tools/jcoverage -lib tools/jcoverage-1.0.5/lib/junit/3.8.1 -lib tools/jcoverage-1.0.5 -lib tools/jcoverage-1.0.5/lib/bcel/5.1 -lib tools/jcoverage-1.0.5/lib/gnu/getopt/1.0.9 -lib tools/jcoverage-1.0.5/lib/log4j/1.2.8 -lib tools/jcoverage-1.0.5/lib/oro/2.0.7 "$@"

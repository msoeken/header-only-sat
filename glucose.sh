#!/bin/bash

wget http://www.labri.fr/perso/lsimon/downloads/softwares/glucose-syrup-4.1.tgz
tar xfz glucose-syrup-4.1.tgz

CORE=glucose-syrup-4.1/core
MTL=glucose-syrup-4.1/mtl
SIMP=glucose-syrup-4.1/simp
UTILS=glucose-syrup-4.1/utils

patch -p0 < patches/glucose-logical-op-parantheses1.patch
patch -p0 < patches/glucose-logical-op-parantheses2.patch
patch -p0 < patches/glucose-logical-op-parantheses3.patch

cat $MTL/IntTypes.h > glucose.hpp
cat $MTL/XAlloc.h >> glucose.hpp
cat $MTL/Vec.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/Alg.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/Alloc.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/Clone.h >> glucose.hpp
cat $MTL/Heap.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/Map.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/Queue.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/Sort.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $MTL/VecThreads.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp

cat $UTILS/ParseUtils.h >> glucose.hpp
cat $UTILS/Options.h | sed -e "s/^#include \"mtl\/.*$//g" -e "s/^#include \"utils\/.*$//g" >> glucose.hpp
cat $UTILS/System.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp

cat $CORE/SolverTypes.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $CORE/BoundedQueue.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $CORE/Constants.h >> glucose.hpp
cat $CORE/SolverStats.h | sed -e "s/^#include \"mtl\/.*$//g" >> glucose.hpp
cat $CORE/Solver.h | sed -e "s/^#include \"mtl\/.*$//g" -e "s/^#include \"core\/.*$//g" -e "s/^#include \"utils\/.*$//g" >> glucose.hpp
cat $CORE/Solver.cc | sed -e "s/^#include \"mtl\/.*$//g" -e "s/^#include \"core\/.*$//g" -e "s/^#include \"utils\/.*$//g" -e "s/^#include\"simp\/.*$//g"  -e "s/using namespace Glucose;/namespace Glucose {/g" >> glucose.hpp
echo "} // using namespace Glucose" >> glucose.hpp

patch glucose.hpp < patches/glucose-function-inline-and-stdout.patch

rm glucose-syrup-4.1.tgz
rm -Rf glucose-syrup-4.1

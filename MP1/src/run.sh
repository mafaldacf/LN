#!/bin/bash

mkdir -p compiled images
symbols=sources/syms.txt


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#                                                                                 #
#                        Compiling all transducers and tests                      #		
#                                                                                 #							
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Compile sources and tests
for i in sources/*.txt tests/*.txt; do
	if [ "$i" != "$symbols" ]; then
		echo "Compiling: $i"
    		fstcompile --isymbols=$symbols --osymbols=$symbols $i | fstarcsort > compiled/$(basename $i ".txt").fst
	fi
done

# Compile auxiliary transducers
echo "Compiling auxiliary transducers"
fstconcat compiled/copy.fst compiled/copy.fst | fstarcsort > compiled/copy2digits.fst # copy 2 digits
fstconcat compiled/copy2digits.fst compiled/copy.fst | fstarcsort > compiled/copy3digits.fst # copy 3 digits
fstconcat compiled/copy2digits.fst compiled/copy2digits.fst | fstarcsort > compiled/copy4digits.fst # copy 4 digits
fstconcat compiled/copy4digits.fst compiled/copy.fst | fstarcsort > compiled/copy5digits.fst # copy 5 digits
fstcompose compiled/R2A.fst compiled/d2dd.fst | fstarcsort > compiled/R2dd.fst # roman numeral to 2 digit arabic number
fstcompose compiled/R2A.fst compiled/d2dddd.fst | fstarcsort > compiled/R2dddd.fst # roman numeral to 4 digit arabic number
fstinvert compiled/R2dd.fst | fstarcsort > compiled/dd2R.fst # 2 or more digit arabic number to roman numeral
fstinvert compiled/R2dddd.fst | fstarcsort > compiled/dddd2R.fst # 4 or more digit arabic number to roman numeral
fstinvert compiled/mm2mmm.fst | fstarcsort > compiled/mmm2mm.fst # 3-letter (english) month names to 2-digit Arabic numbers
fstcompose compiled/mmm2mm.fst compiled/dd2R.fst | fstarcsort > compiled/mmm2R.fst # 3-letter (english) month names to roman numeral

# Compile 'A2R'
echo "Compiling: sources/A2R.txt"
fstinvert compiled/R2A.fst > compiled/A2R.fst

# Compile 'birthR2A'
echo "Compiling: sources/birthR2A.txt"
fstconcat compiled/R2dd.fst compiled/copy.fst | fstarcsort > compiled/birthR2A-aux1.fst # R/ -> dd/
fstconcat compiled/birthR2A-aux1.fst compiled/birthR2A-aux1.fst | fstarcsort > compiled/birthR2A-aux2.fst # R/R/ -> dd/dd/
fstconcat compiled/birthR2A-aux2.fst compiled/R2dddd.fst  | fstarcsort > compiled/birthR2A.fst # R/R/R -> dd/dd/dddd

# Compile 'birthA2T'
echo "Compiling: sources/birthA2T.txt"
fstconcat compiled/copy3digits.fst compiled/mm2mmm.fst | fstarcsort > compiled/birthA2T-aux.fst
fstconcat compiled/birthA2T-aux.fst compiled/copy5digits.fst | fstarcsort > compiled/birthA2T.fst

# Compile 'birthT2R'
echo "Compiling: sources/birthT2R"
fstconcat compiled/dd2R.fst compiled/copy.fst | fstarcsort > compiled/birthT2R-aux1.fst
fstconcat compiled/birthT2R-aux1.fst compiled/mmm2R.fst | fstarcsort > compiled/birthT2R-aux2.fst
fstconcat compiled/birthT2R-aux2.fst compiled/copy.fst  | fstarcsort > compiled/birthT2R-aux3.fst
fstconcat compiled/birthT2R-aux3.fst compiled/dddd2R.fst  | fstarcsort > compiled/birthT2R.fst

# Compile 'birthR2L'
echo "Compiling: sources/birthR2L.txt"
fstcompose compiled/birthR2A.fst compiled/date2year.fst | fstarcsort > compiled/birthR2year.fst
fstcompose compiled/birthR2year.fst compiled/leap.fst | fstarcsort > compiled/birthR2L.fst


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#                                                                                 #
#                       Testing transducers and generating pdf's                  #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Testing transducer 'birthR2A' (pdf)
echo "Testing the transducer 'birthR2A' with the input '92513birthR.txt' (generating pdf)"
fstcompose compiled/92513birthR.fst compiled/birthR2A.fst | fstshortestpath > compiled/92513birthR2A.fst
echo "Testing the transducer 'birthR2A' with the input '92546birthR.txt' (generating pdf)"
fstcompose compiled/92546birthR.fst compiled/birthR2A.fst | fstshortestpath > compiled/92546birthR2A.fst

# Testing transducer 'birthA2T' (pdf)
echo "Testing the transducer 'birthA2T' with the input '92513birthA.txt' (generating pdf)"
fstcompose compiled/92513birthA.fst compiled/birthA2T.fst | fstshortestpath > compiled/92513birthA2T.fst
echo "Testing the transducer 'birthA2T' with the input '92546birthA.txt' (generating pdf)"
fstcompose compiled/92546birthA.fst compiled/birthA2T.fst | fstshortestpath > compiled/92546birthA2T.fst

# Testing transducer 'birthT2R' (pdf)
echo "Testing the transducer 'birthT2R' with the input '92513birthT2R.txt' (generating pdf)"
fstcompose compiled/92513birthT.fst compiled/birthT2R.fst | fstshortestpath > compiled/92513birthT2R.fst
echo "Testing the transducer 'birthT2R' with the input '92546birthT2R.txt' (generating pdf)"
fstcompose compiled/92546birthT.fst compiled/birthT2R.fst | fstshortestpath > compiled/92546birthT2R.fst

# Testing transducer 'birthR2L' (pdf)
echo "Testing the transducer 'birthR2L' with the input '92513birthR.txt' (generating pdf)"
fstcompose compiled/92513birthR.fst compiled/birthR2L.fst | fstshortestpath > compiled/92513birthR2L.fst
echo "Testing the transducer 'birthR2L' with the input '92546birthR.txt' (generating pdf)"
fstcompose compiled/92546birthR.fst compiled/birthR2L.fst | fstshortestpath > compiled/92546birthR2L.fst


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#                                                                                 #
#                                Creating images (pdf)                            #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


# Creating images (pdf)
for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    	fstdraw --portrait --isymbols=$symbols --osymbols=$symbols $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#                                                                                 #
#                           Testing transducers to stdout                         #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Testing transducer 'birthR2A' (stdout)
echo "Testing the transducer 'birthR2A' with the input '92513birthR.txt' (stdout)"
fstcompose compiled/92513birthR.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols
echo "Testing the transducer 'birthR2A' with the input '92546birthR.txt' (stdout)"
fstcompose compiled/92546birthR.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols

# Testing transducer 'birthA2T' (stdout)
echo "Testing the transducer 'birthA2T' with the input '92513birthA.txt' (stdout)"
fstcompose compiled/92513birthA.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols
echo "Testing the transducer 'birthA2T' with the input '92546birthA.txt' (stdout)"
fstcompose compiled/92546birthA.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols

# Testing transducer 'birthT2R' (stdout)
echo "Testing the transducer 'birthT2R' with the input '92513birthT.txt' (stdout)"
fstcompose compiled/92513birthT.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols
echo "Testing the transducer 'birthT2R' with the input '92546birthT.txt' (stdout)"
fstcompose compiled/92546birthT.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols

# Testing transducer 'birthR2L' (stdout)
echo "Testing the transducer 'birthR2L' with the input '92513birthR.txt' (stdout)"
fstcompose compiled/92513birthR.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols
echo "Testing the transducer 'birthR2L' with the input '92546birthR.txt' (stdout)"
fstcompose compiled/92546birthR.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./$symbols

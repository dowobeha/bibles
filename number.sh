#!/bin/bash

# Re-number directories so that they are in the right order

dir=esu-YPK

i=0

for book in $(cut -f 1 books.tsv); do 

	i=$(($i + 1))
	
	j=$i
	
	if (( $j < 10 )) ; then  
		
		j="0$j"
		
	fi 
	
	mv ${dir}/${book} ${dir}/${j}_${book}
	
done


#!bin/bash

file=worldcupplayerinfo.tsv
outfile=work_2.txt

function main(){
	

	TotalNumber=$( sed -e '1d' $file | wc -l )

        Number1=$( sed -e '1d' $file | awk -F '\t' '{if($6<20) print $9}' | wc -l)
	Number2=$( sed -e '1d' $file | awk -F '\t' '{if(($6>20 || $6==20) && ($6<30 || $6==30)) print $9}' | wc -l)
	Number3=$( sed -e '1d' $file | awk -F '\t' '{if($6>30) print $9}' | wc -l)
	NumberG=$( sed -e '1d' $file | awk -F '\t' '{if( $5 == "Goalie" ) print $9}' | wc -l )
	NumberD=$( sed -e '1d' $file | awk -F '\t' '{if( $5 == "Defender" ) print $9}' | wc -l )
	NumberM=$( sed -e '1d' $file | awk -F '\t' '{if( $5 == "Midfielder" ) print $9}' | wc -l )
	NumberF=$( sed -e '1d' $file | awk -F '\t' '{if( $5 == "Forward" ) print $9}' | wc -l )


	Percent1=$(awk "BEGIN { y=100*${Number1}/${TotalNumber}; print y }")
        Percent2=$(awk "BEGIN { y=100*${Number2}/${TotalNumber}; print y }")
	Percent3=$(awk "BEGIN { y=100*${Number3}/${TotalNumber}; print y }")
	PercentG=$(awk "BEGIN { y=100*${NumberG}/${TotalNumber}; print y }")
	PercentD=$(awk "BEGIN { y=100*${NumberD}/${TotalNumber}; print y }")
	PercentM=$(awk "BEGIN { y=100*${NumberM}/${TotalNumber}; print y }")
	PercentF=$(awk "BEGIN { y=100*${NumberF}/${TotalNumber}; print y }")



	longN=$(sed -e '1d'  $file | awk -F '\t' '{print $9}' | awk ' NR==1 {x=length($0)};NR>=2 {if ( length($0) > x  ) { x = length($0) } } END{ print x }')
	shortN=$(sed -e '1d' $file | awk -F '\t' '{print $9}' | awk ' NR==1 {x=length($0)};NR>=2 {if (( length($0) < x) && (length($0) > 0 )){ x = length($0) } } END{ print x }' )
	oldN=$(sed -e '1d' $file | awk -F '\t' ' NR==1{old=$6};NR>=2{if($6>old){old =$6} } END{print old} '  )
	youngN=$(sed -e '1d' $file | awk -F '\t' ' NR==1{young=$6};NR>=2{if(($6<young)&&($6>0)){young =$6} } END{print young} '  )



echo "The number of players under 20-year-old is:$Number1,percentage:$Percent1%." >$outfile
echo "The number of players between 20 and 30 years old is:$Number2,percentage:$Percent2%." >>$outfile 
echo "The number of players above 30-year-old is:$Number3,percentage:$Percent3%." >>$outfile  

echo "The number of players in the Goalie is:$NumberG,percentage:$PercentG%."  >>$outfile
echo "The number of players in the Defender is:$NumberD,percentage:$PercentD%."  >>$outfile 
echo "The number of players in the Midfielder is:$NumberM,percentage:$PercentM%."  >>$outfile 
echo "The number of players in the Forward is:$NumberF,percentage:$PercentF%."  >>$outfile 
  
echo "The longest name is:" >>$outfile
echo $(sed -e '1d' $file|awk -F '\t' '{if ( length($9)=='$longN' ) print $9}') >>$outfile

echo "The shortest name is:" >>$outfile
echo $(sed -e '1d' $file|awk -F '\t' '{if ( length($9)=='$shortN' ) print $9}') >>$outfile

echo "The oldest age is:$oldN,they are:"  >>$outfile
echo $(sed -e '1d' $file|awk -F '\t' '{if ( $6=='$oldN') print $9}')  >>$outfile

echo "The youngest age is:$youngN,they are:"  >>$outfile
echo $(sed -e '1d' $file|awk -F '\t' '{if ( $6=='$youngN') print $9}') >>$outfile
}


main

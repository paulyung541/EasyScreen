#!/bin/bash
############################################################
# convert the "xxdp" to "@dimen/DIMEN_ATTRIBUTE_NAME_xx.0" #
############################################################

#dp属性名
DIMEN_ATTRIBUTE_NAME="xdp"
#sp属性名
SP_ATTRIBUTE_NAME="xsp"

#exit
function fun_exit_shell() {
	echo "exit"
	exit	
}

function fuc_replace() {
	cd $1
	
	echo "~~~~~~~~~~~~~~~~~ start replace! ~~~~~~~~~~~~~~~~~"
	
	#all file iterator
	for file in $(ls .)
	do
		if [ ! -d $file ]
		then
			echo "FILE NAME ======================== "$file
			cat $file | while read old_line
			do 
				new_line=$old_line
				
				#replace dp
				the_num_dp=`echo ${new_line} | grep -o '[0-9]*dp'`
				
				if [ "$the_num_dp" != "" -a "$the_num_dp" != "dp" ]
				then
					#get num
					the_num=`echo ${the_num_dp} | grep -o '[0-9]*'`
					#get the new line like: @dimen/auto_dp_10.0
					new_line=`echo ${new_line/[0-9]*dp/@dimen/${DIMEN_ATTRIBUTE_NAME}_${the_num}.0}`
					echo $new_line
					sed -i "s#${old_line}#${new_line}#g" $file
				fi
				
				#replace sp
				the_num_sp=`echo ${new_line} | grep -o '[0-9]*sp'`
				if [ "$the_num_sp" != "" -a "$the_num_sp" != "sp" ]
				then
					#get num
					the_num=`echo ${the_num_sp} | grep -o '[0-9]*'`
					#get the new line like: @dimen/auto_sp_10
					new_line=`echo ${new_line/[0-9]*sp/@dimen/${SP_ATTRIBUTE_NAME}_${the_num}}`
					echo $new_line
					sed -i "s#${old_line}#${new_line}#g" $file
				fi
			done
		fi
	done 
	cd -
}

#--------------------------------------- the shell start ---------------------------------------

# check current dir
if [ ! -d "src/main/res" ]
then
	echo "please execute this shell in the main module root dir!"
	fun_exit_shell
fi

echo "read dir success!"

cd src/main/res

for dir in $(ls .)
do
    if [[ `echo ${dir}` =~ "layout" ]]
	then
		echo $dir
		fuc_replace $dir
	fi
	
	echo "~~~~~~~~~~~~~~~~~ all have been replaced success! ~~~~~~~~~~~~~~~~~"
done  
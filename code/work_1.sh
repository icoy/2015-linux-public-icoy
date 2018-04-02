#!bin/bash

# 对jpeg格式图片进行图片质量压缩
function Compress_Quality 
{                                                                                                                 
    	for i in $(find $2 -regex  '.*\.jpg');do


		filename=$(basename $i)
	    	name="${filename%.*}"
		extension="${filename#*.}"
        	convert $i -quality $1 $2/"$name""%$1".$extension;

	done
}

# 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function Compress_Resolution 
{

	for i in $(find $2 -regex  '.*\.jpg\|.*\.svg\|.*\.png');do

		filename=$(basename $i)
	    	name="${filename%.*}"
		extension="${filename#*.}"
		convert $i -resize $1 $2/"$name""--$1".$extension;

	done
# 对图片批量添加自定义文本水印
function Embed 
{

	for i in $(find $2 -regex  '.*\.jpg\|.*\.svg\|.*\.png');do

		width=$(identify -format %w $i)

		filename=$(basename $i)
	    	name="${filename%.*}"
		extension="${filename#*.}"

		convert -background '#0008' -fill blue -gravity center \
		-size "${width}"x30 caption:$1 $i +swap -gravity south \
		-composite $2/"$name""_embed".$extension

	done
}

# 批量重命名

#前缀
function Prefix_add
{

	for i in $(find $2 -regex  '.*\.*'); do

		filename=$(basename $i)
	    	name="${filename%.*}"
		extension="${filename#*.}"
		cp $i $2/$1$name.$extension

	done
}
#后缀
function Suffix_add
{

	for i in in $(find $2 -regex  '.*\.*'); do

		filename=$(basename $i)
	    	name="${filename%.*}"
		extension="${filename#*.}"
		cp $i $2/$name$1.$extension

	done
}

# 将png/svg图片统一转换为jpg格式图片
function Convert
{
	for i in $(find "$1" -regex '.*\.svg\|.*\.png');do

		filename=$(basename $i)
	    	name="${filename%.*}"
		extension="${filename#*.}"

		convert $i $1/$name.jpg

	done
}


# 帮助文档
function Help 
{
	echo "For example: bash work_1.sh [option] [option2] [path]"
	echo "2 options:"
	echo "-q|--quality -'quality'	对jpeg格式图片进行图片质量压缩"	
	echo "-s|--size -'size'   	对jpeg/png/svg格式图片压缩分辨率"
	echo "-e|--embed -'string'	对图片批量添加自定义文本水印"	
	echo "-p|--prefix -'string'	批量重命名(前缀)"
	echo "-s|--suffix -'string'	批量重命名(后缀)"
	echo "-c|--convert 		将png/svg图片统一转换为jpg格式图片"
	echo "--help"
}


#main


if [[ "$#" -lt 1 ]]; then
	echo "no primary parameters!";
        exit 1;
else
	while true ; do
		case "$1" in	
		-q|--quality)
			if [[ "$2" != '' ]]; then 
				Compress_Quality "$2" "$3";shift 2;
			else 
				echo "no parameter about quality!"
			fi;exit 0;;
				
		-s|--size)
			if [[ "$2" != '' ]]; then 
				Compress_Resolution "$2" "$3";shift 2;
			else 
				echo "no parameter about resize rate!"
			fi;exit 0;;
				
		-e|--embed)
			if [[ "$2" != '' ]]; then 
				Embed "$2" "$3";shift 2
			else 
				echo " no string to be embeded!"
			fi;exit 0;;
				
		-p|--prefix)
			if [[ "$2" != '' ]]; then 
				Prefix_add "$2" "$3";shift 2
			else
				echo "no parameter about prefix!"
			fi;exit 0;;
				
		-s|--suffix)
			if [[ "$2" != '' ]]; then 
				Suffix_add "$2" "$3";shift 2;
			else 
				echo "no parameter about suffix!"
			fi;exit 0;;
			
		-c|--convert)
			Convert "$2"
			shift;exit 0;;
				
		--help)
			Help
			exit 0;;
		--)
			shift;break ;;
		*)
			echo "not correct parameters!"
			exit 1;;
		esac
	done

fi





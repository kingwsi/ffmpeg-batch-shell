#!/bin/bash
exist_file()
{
    if [ -e "$1" ]
    then
        return 1
    else
        return 2
    fi
}

exist_file *.mp4
value=$?
now=$(date "+%Y-%m-%d %H:%M:%S")
# 是否有文件
if [ $value -eq 1 ]
then
	echo "${now}\t\t|发现文件，开始转换" >> ffmpeg.log
else
	echo "${now}\t\t|未发现待处理文件" >> ffmpeg.log
fi

source_folder="./"
out_folder="./output/"
old_folder="./old/"
global_start_time=`date "+%s"`

# 文件夹处理
if [ ! -d "${out_folder}" ]
then
	echo "创建文件夹${out_folder}"
       	mkdir ${out_folder}
fi
if [ ! -d "${old_folder}" ]
then
	mkdir ${old_folder}
	echo "创建文件夹${out_folder}"
fi

# 处理带空格的文件
for file in `ls . | grep ".mp4" | tr " " "?"`
do
	echo '文件名去空格处理'
	mv "$file" `echo "$file" | sed 's/ //g'`
done

for file in `ls $source_folder | grep ".mp4" | tr " " "?"`
do
	echo "------start-------"
	file_convert_start_time=`date "+%s"`
	echo "转换--->"$file
	out_filename=`basename "$file"`
	out_path=${out_folder}${out_filename}
	ffmpeg -i "$file" -vcodec h264 "$out_path"
	# 转换耗时
	file_convert_end_time=`date "+%s"`
	echo "$(date "+%Y-%m-%d %H:%M:%S")\t\t|${file}\t\t|耗时$((($file_convert_end_time-$file_convert_start_time)/60)) 分钟" >> ffmpeg.log
	# 将原文件移动到指定目录
	mv "$file" $old_folder
done
# 总耗时
global_end_time=`date "+%s"`
echo "${file}\\t总耗时$((($global_end_time-$global_start_time)/60)) 分钟" >> ffmpeg.log

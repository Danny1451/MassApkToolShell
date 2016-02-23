#!/bin/bash


#----------------------
#这是对一个文件夹的apk进行反编译的脚本
#批量反编译
#----------------------


function apkSigner(){

echo "for signer="$1

keyPath="这边输入签名路径"
keyName="签名名称"
keyPass="签名密码"

package=$1
newName=${package%%.*}"-Signed.apk"

jarsigner -verbose -keystore $keyPath -signedjar $newName $package $keyName -storepass $keyPass

}

function apktoolUpZip(){

echo $1,$2;

if [ ! -d "$2" ]; then

		apktool d $1 -o $2

		echo $1"反编译完成"
else
		echo "该文件已存在是否要覆盖？"

		select var in "覆盖" "跳过"; do
				break;
		done

		if [ "$var" = "覆盖" ]; then

				rm -rf $2
				apktool d $1 -o $2

				echo "已经覆盖解压"

		else
				echo "已经跳过解压"
		fi

fi


}

function massUpZip(){

echo '输入要反编译的文件夹目录'

read sources

sourcesFlorder=$sources
targetFlorder=$sources"Track" 
if [ ! -d "$sourcesFlorder" ]; then

		echo "没有该目录 请检查目录是否正确！"
		exit 0

fi

if [ ! -d "$targetFlorder" ]; then

		echo "解压至目标目录"$targetFlorder

		mkdir "$targetFlorder"

		chmod 777 "$targetFlorder"

fi

size=0

for file_a in ${sourcesFlorder}/*; do  
		temp_file=$file_a
		temp_file_name=`basename $file_a`
		#	apktool d $temp_file -o $targetFlorder"/"$temp_file_name
		apktoolUpZip  $temp_file $targetFlorder"/"$temp_file_name

		size=$[$size+1]

		
done 

echo "批量反编译完成，共完成"$size"个"
}


function apktoolZip(){

echo $1;
name=$1;
newName=${name%%.*}"NewBuild.apk"

if [ ! -d "$2" ]; then

		apktool b $1 -o $newName
		apkSigner $newName 

		echo $newName"打包完成"
else
		echo "该文件已存在是否要覆盖？"

		select var in "覆盖" "跳过"; do
				break;
		done

		if [ "$var" = "覆盖" ]; then

				rm -rf $newName
				apktool b $1 -o $newName

				echo "已经覆盖解压"

		else
				echo "已经跳过解压"
		fi

fi


}


function massZip(){
echo '输入要打包的反编译文件夹目录'

read sources

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
sourcesFlorder=$DIR"/"$sources
if [ ! -d "$sourcesFlorder" ]; then

		echo "没有该目录 请检查目录是否正确！"
		exit 0

fi


size=0

for file_a in ${sourcesFlorder}/*; do  
		temp_file=$file_a
		#	apktool d $temp_file -o $targetFlorder"/"$temp_file_name
		apktoolZip  $temp_file

		size=$[$size+1]

		echo "批量打包完成，共完成"$size"个"
done 


}


echo $1

if [ $1 = "zip" ]; then

		echo "是否批量打包？"

		select var in "批量" "单个"; do
				break;
		done

		if [ "$var" = "批量" ]; then

				massZip

		else

				echo "输入需要打包的文件路径："

				read singleName

				while [ ! -d "$singleName" ]; do
						echo "不存在该文件,请重新输入："
						read singleName
						break
				done

				apktoolZip  $singleName $singleName"Track"

		fi

else
		echo "是否批量反编译？"

		select var in "批量" "单个"; do
				break;
		done

		if [ "$var" = "批量" ]; then

				massUpZip

		else

				echo "输入需要反编译的文件路径："

				read singleName

				while [ ! -d "$singleName" ]; do
						echo "不存在该文件,请重新输入："
						read singleName
						break
				done

				apktoolUpZip  $singleName $singleName"Track"

		fi

fi



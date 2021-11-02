read -p "Remove task file? [y/n]" a
if [ $a == y ]; then
       	rm ~/movie.sh
       	i=0
fi
workdir=/home/osmc/hgst8t/BT
outdir=/home/osmc/hgst8t/movies
mntdir=~/mount
cd $workdir
while [ 1 ]
do
	read -p "Enter the movie name: " mvname
	if [ -z "$mvname" ]; then 
	       	echo "movie finish"
	       	break
	fi

	#into movie dir
	if [ -d *"$mvname"* ]; then
		cd *"$mvname"*
		if [ -d BDMV ]; then
			cd BDMV/STREAM
			echo $PWD
		elif [ -f *"$mvname"*.iso ]; then
			sudo mount -o loop *"$mvname"*.iso $mntdir/loop$i
			cd $mntdir/loop$i/BDMV/STREAM && i=$(($i+1))
			echo $PWD
		else
			echo "The movie is not exist"
			break
		fi
	elif [ -f *"$mvname"*.iso ]; then
		sudo mount -o loop *"$mvname"*.iso $mntdir/loop$i
		cd $mntdir/loop$i/BDMV/STREAM
		i=$(($i+1))
		echo $PWD
	else
		echo "The movie is not exist"
		break
	fi

	#find the largest m2ts
	m2ts=$(find . -type f -printf '%s %p\n' | sort -nr | head -n 1 | cut -d '/' -f2)

	mkvmerge -i $m2ts
	
	#audio argument
	read -p "Enter audio track id: " aunum
	while [ 1 ]
	do
		read -p "Enter number:name of the audio: " auname
		if [ -z "$auname" ]; then
			break
		else
			allauname="$allauname--track-name $auname "
		fi
	done
	auarg="-a $aunum $allauname"

	#subtitle argument
	read -p "Enter subtitle track id: " subnum
	while [ 1 ]
	do
		read -p "Enter number:name of the subtitle: " subname
		if [ -z "$subname" ]; then
			break
		else
			allsubname="$allsubname--track-name $subname "
		fi
	done
	subarg="-s $subnum $allsubname"

	fullarg=$auarg$subarg
	echo $fullarg
	fullcmd="mkvmerge -o $outdir/\"$mvname\".mkv $fullarg \"$PWD\"/$m2ts"
	echo $fullcmd | tee -a ~/movie.sh

	unset allauname
	unset allsubname

	cd $workdir
done

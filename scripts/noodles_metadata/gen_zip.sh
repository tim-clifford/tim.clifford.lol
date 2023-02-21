dir="Noodles Vol. 0: reflections and phantoms"
mkdir "$dir"
cd "$dir"
cp ../side_a/*.flac .
perl-rename 's/^/A/g' *
cp ../side_b/*.flac .
sh ~/sftp/music/scripts/rename.sh
rm -r originals
ls *.flac > '[0:00] Noodles Vol. 0: reflections and phantoms.m3u'
ls '[1:'*.flac > '[1:00] Noodles Vol. 0: reflections.m3u'
ls '[2:'*.flac > '[2:00] Noodles Vol. 0: phantoms.m3u'
cp ../metadata/cover.png .
cd ..
zip -r vol_0.zip "$dir"

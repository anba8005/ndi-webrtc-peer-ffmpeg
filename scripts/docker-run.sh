mkdir ../ffmpeg-install
docker run -v $PWD/../ffmpeg-install:/ffmpeg-install --rm -it gyvaitv-ffmpeg-linux:latest "$@"

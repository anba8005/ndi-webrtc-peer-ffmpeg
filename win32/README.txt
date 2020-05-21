1. install vcpkg
2. copy Control and portfile to ports/ffmpeg
3. copy ndi includes to vcpkg installed include dir
4. copy ndi appropriate lib to vcpkg installed lib dir AND vcpkg debug lib dir
5. replace -lndi to -lProcessing.NDI.Lib.x64 in buildtrees/ffmpeg/configure
6. vcpkg install ffmpeg[x264,gpl,nonfree,ffmpeg]:x64-windows-static

p.s. no opus support
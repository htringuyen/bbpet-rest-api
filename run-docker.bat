@echo off
set IMAGE_NAME=jtomcat

for /F "tokens=*" %%i in ('docker image inspect %IMAGE_NAME% 2^>^&1 ^| findstr /R /C:"Error:"') do (
    set ERROR=%%i
)

if defined ERROR (
    echo Image %IMAGE_NAME% not found. Building...
    docker build -t %IMAGE_NAME% docker
) else (
    echo Image %IMAGE_NAME% found.
)

docker run -v %cd%:/home/project --name bbpet-webapi -p 8080:8080 %IMAGE_NAME%


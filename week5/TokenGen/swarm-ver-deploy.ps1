﻿
$serviceName = "tokengen"

# parse project.json and extract app version
$rootPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$projectPath = "$rootPath\src\TokenGen\project.json"
$json = Get-Content -Raw -Path $projectPath | ConvertFrom-Json
$version = $json.version.Split("-")[0]

# tag docker image with app version
$imageName = "$serviceName-img:$version"

# build image
if(docker images -q $imageName){
    "Image $imageName exists!"
    return 
}else{
    docker build -t $imageName -f "$rootPath\TokenGen.dockerfile" $rootPath
}

# create service
docker service create --publish 5000:5000 --name $serviceName --replicas 3 --update-delay 5s $imageName




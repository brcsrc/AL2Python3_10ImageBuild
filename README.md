# AL2Python3_10ImageBuild
Dockerfile to build Python 3.10 from source with OpenSSL 1.1.1 from source on Amazon Linux 2 base image

### Use Case
In developing python based lambda functions on AWS, there will sometimes be cases where the packages used in development environment
are built for your environment and is not compatible with the lambda platform, which should be a derivative of amazon linux 2. At 
time of writing, the [Amazon Linux 2 base image](https://hub.docker.com/_/amazonlinux) ships with python3.7 and openssl 1.0.2. To 
use python 3.10 on mentioned AL2 image it must be built from source as the preconfigured yum repos offers python 3.7 as latest. 
To build python 3.10 from source, openssl 1.1.1 is required, which al2 offers 1.0.2 as latest. 
This image aims to provide an intermediate environment that includes python3.10 where you can load your source code into and build
with dependencies that will be compatible with the lambda platform

##### Build
```shell
docker build . -t amazonlinux2-python3_10:latest
```

##### Run and source python dependencies
the container can be run and held in running state
```shell
docker run -d --name artifactbuilder amazonlinux2-python3_10:latest tail -f /dev/null
```

assuming you have a project structured somewhat like
```shell
.
├── requirements.txt
├── setup.py
├── src
│   ├── your_python_package
│   │   ├── __init__.py
│   │   └── lambdas
│   │       ├── __init__.py
│   │       └── your_handler.py
```
you can copy the project structure into the running container and source your dependencies
```shell
docker cp . artifactbuilder:/app 

docker exec artifactbuilder /usr/local/bin/pip3.10 install /app/requirements.txt /app
```
then zip and pull from container
```shell
docker exec artifactbuilder zip your_python_package.zip /app

docker cp artifactbuilder:/your_python_package.zip .
```

of you can reference in another docker file to start from
```dockerfile
FROM amazonlinux2-python3_10:latest
```

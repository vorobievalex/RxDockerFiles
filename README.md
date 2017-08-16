# RxDockerFiles

## What's in this repository?

The rxBase image is based on the [microsoft/dotnet-framework](https://hub.docker.com/r/microsoft/dotnet-framework/) image and is able to run Ranorex test executables in a docker environment.<br>
**Important:** Windows docker containers are needed! This image does not run under Linux and currently only works with a docker daemon running on Win10 or Win Server 2016 (more see [here](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-server)).

## How to build the image?

First 'cd' into the 'rxBase' folder, e.g., via powershell. The image build ist started with the following command.

```
docker build --build-arg rxVersion=7.1.0 -t ranorex/runtime:7.1.0 .
```

The Dockerfile accepts a build-argument to specify the Ranorex version. The vcredist packages are automatically installed from the Ranorex.msi zip file. Internet access is required for now. More information regarding Dokcerfiles and how to build images is available [here](https://docs.docker.com/engine/reference/builder/).

## How to run the Ranorex test?

1. Place your Ranorex test exe + additional files in a folder (in the example below: _'C:\Users\User\docker\testfiles'_)<br>
  **Important:** The Ranorex testing .exe must be named `test.exe`. A powershell script placed in the container automatically starts this exe upon container start.

  _Hint:_ Delete all files in the 'Debug' or 'Release' folder, then rebuild the solution and copy all files which have been newly created.

2. Create a directory where the report files should be placed (in the example below: _'C:\Users\User\docker\report'_)

3. Run the test with the following command below. The `-v` parameter binds the folder with the test-files to the folder _C:\rxTestFiles_ in the container and also does the same for the report files.

```
docker run -v C:\Users\User\docker\testfiles:C:\rxTestFiles -v C:\Users\User\docker\report:C:\report ranorex/runtime:7.1.0
```

The Ranorex test then gets executed in the container and the report is placed in the specified report folder. The report is automatically created as .html and a compressed report file is also placed in the report folder. If you'd like to modify the execution behavior, please modify the [runtest.ps1](https://github.com/cbreit/RxDockerFiles/blob/master/rxBase/runTest.ps1) powershell script by yourself and rebuild the container on your own.

**Additional Arguments:** If you'd like to hand over additional arguments like the selection of a test case, custom parameter values, etc., simply append them to the docker command:

```
docker run -v <testFilesLocation>:C:\rxTestFiles -v <reportFilesLocation>:C:\report ranorex/runtime:7.1.0  /tc:myTcToStart /pa:myParam=SomeValue
```

_(see the_ `/tc:myTcToStart /pa:myParam=SomeValue` _arguments at the end)_

## What about the Ranorex license?

There are two options:

1. Copy the `Ranorex3_Server.lic` file directly to the testing files. In this case, the test will automatically use the license server specified in the file.
2. Place the `Ranorex3_Server.lic` file in the image. There's already a commented line for this in the Dockerfile You could simply copy the license file in the _'C:\ProgramData'_ folder

_Note:_ Dependent on your configuration, the container might not be able to resolve hostnames properly. In this case, manually edit the .lic file and enter the IP of the license server.

## Limitations

Windows docker container don't provide a desktop (or some simulation) right now. It is thus at the moment only possible to run Ranorex Selenium or mobile tests from such a container, which are driving the automation on some endpoint.

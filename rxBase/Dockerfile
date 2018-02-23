FROM microsoft/dotnet-framework:4.6.2-windowsservercore-10.0.14393.1480

ARG rxVersion=7.2.0
ENV rxVersion ${rxVersion}

LABEL vendor="Ranorex" \ 
      maintainer="Christian Breitwieser" \
      type="Ranorex Runtime" \
      ranorexVersion=${rxVersion} \
      description="This is a docker base image which contains the necessary components to execute Ranorex test excutables."
      
ADD installRanorex.ps1 ./installRanorex.ps1
ADD installChoco.ps1 ./installChoco.ps1
RUN powershell .\installChoco.ps1

ADD https://www.ranorex.com/download/Ranorex-${rxVersion}.zip Ranorex-install.zip
RUN powershell .\installRanorex.ps1 -zipPackage:Ranorex-install.zip & \
    del installRanorex.ps1 & \
    del installChoco.ps1 & \
    del Ranorex-install.zip

# If no license server file is provided by the customer together with his app, the license
# file in "ProgramData" is used.
# It needs to point to a license-server running internally

#COPY Ranorex3_Server.lic /ProgramData
    
# the place where the ranorex test .exe resides in
# and the place where the ranorex results get placed
# will be bound with a volume
RUN mkdir C:\rxTestFiles & \
    mkdir C:\report

WORKDIR \rxTest

ADD runtest.ps1 /runtest.ps1

ENTRYPOINT powershell -noexit  c:\runtest.ps1

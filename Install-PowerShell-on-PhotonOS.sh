#################################################################
#                                                               #
# CHANGE THIS VARIABLE TO THE PWSH VERSION YOU WISH TO INSTALL  #
#                                                               #
#################################################################

export PS_VERSION=6.2.3

#################################################################
#                                                               #
#        DO NOT CHANGE ANYTHING BELOW THIS LINE                 #
#                                                               #
#################################################################


# Set working directory (save install here too)
cd /root

# Prereq
tdnf -y install \
	glibc-i18n \
	gzip \
	tar \
	icu \
	less \
	unzip


#################################################################
#                                                               #
#                     Install Manually                          #
#                  Set up needed ENV first                      #
#                                                               #
#################################################################

# Define Args and ENV required
export PS_PACKAGE=powershell-${PS_VERSION}-linux-x64.tar.gz
export PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}
export PS_INSTALL_VERSION=6


# SET PROPER PWSH LOCATION PER PHOTONOS BUILDS
export PS_INSTALL_FOLDER=/opt/microsoft/powershell/$PS_INSTALL_VERSION

# Download the PowerShell Core Linux tar.gz and save it
curl -o /tmp/powershell-linux.tar.gz -J -L ${PS_PACKAGE_URL}

# Start installing
# Create PowerShell folder
mkdir -p ${PS_INSTALL_FOLDER} \
    && tar zxf /tmp/powershell-linux.tar.gz -C ${PS_INSTALL_FOLDER}
	
# Post-install

# Define ENVs for Localization/Globalization
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Setup PowerShell module analysis cache path
export PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache

# Opt out of SocketsHttpHandler in DotNet Core 2.1 to use HttpClientHandler
# with installed libcurl4 package to resolve
# Invoke-WebRequest : Authentication failed" issue when executing using
# docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [Invoke-WebRequest] [-Uri <HTTPS URL>]
export DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER=0

# Set terminal because there is no xterm library in Photon image
export TERM=screen-256color

# Properly generate needed locale data
locale-gen.sh

# Create the pwsh symbolic link that points to PowerShell
ln -sfn ${PS_INSTALL_FOLDER}/pwsh /usr/bin/pwsh \

# Grant all user execute permissions and remove write permissions for others
chmod a+x,o-w ${PS_INSTALL_FOLDER}/pwsh \

# Intialize the PowerShell module cache
pwsh \
	-NoLogo \
	-NoProfile \
	-Command " \
	  \$ErrorActionPreference = 'Stop' ; \
	  \$ProgressPreference = 'SilentlyContinue' ; \
	  while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {  \
		Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
		Start-Sleep -Seconds 6 ; \
	  }"
	
	
# Finally set the terminal otherwise face bad PSReadline behavior
echo "/usr/bin/pwsh" >> /etc/shells && \
    echo "/bin/pwsh" >> /etc/shells

#################################################################
#                                                               #
#                   INSTALL COMPLETE                            #
#                                                               #
#################################################################

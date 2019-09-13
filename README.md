*Install-PowerShell-on-PhotonOS*: The proper way to install/update PowerShell on PhotonOS
===================================================================
###### by Collin Chaffin  
[![Twitter Follow](https://img.shields.io/twitter/follow/collinchaffin.svg?style=social)](https://twitter.com/collinchaffin)

[![Development Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)](https://raw.githubusercontent.com/CollinChaffin/Install-PowerShell-on-PhotonOS/master/README.md)[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CollinChaffin/Install-PowerShell-on-PhotonOS/master/LICENSE)[![GitHub stars](https://img.shields.io/github/stars/collinchaffin/Install-PowerShell-on-PhotonOS)](https://github.com/CollinChaffin/Install-PowerShell-on-PhotonOS/stargazers)[![GitHub forks](https://img.shields.io/github/forks/collinchaffin/Install-PowerShell-on-PhotonOS)](https://github.com/CollinChaffin/Install-PowerShell-on-PhotonOS/network)[![GitHub issues](https://img.shields.io/github/issues/collinchaffin/Install-PowerShell-on-PhotonOS)](https://github.com/CollinChaffin/Install-PowerShell-on-PhotonOS/issues)


Description:
------------

This script performs a proper install/update of PowerShell on PhotonOS.

Currently, the PhotonOS repos (including DEV) have critical core applications such as PowerShell, Docker, etc. that are simply not being updated at any reasonable regular interval.

I previously used several posted "manual" methods of updating PWSH to find that they were simply not correct, and wound up with PWSH that launched but then had various issues such as missing core modules (PackageManagement, PowerShellGet, others), missing generated cache and locale.

So, I researched exactly how the very outdated PWSH PhotonOS package was originally built and converted that code to the EXACT same steps AND PATHS (which were also wrong in EVERY other manual method I saw posted) to a simple executable shell script.

This script, once `chmod +x` applied, will perform ALL the same steps as the default PhotonOS outdated PWSH install, but install **any version of PWSH** you desire.  I originally designed it for interactive-use and prompt for the desired version to install, but changed course as I found as part of a build process that it should simply run quickly and fairly silently (barring errors).

> **Please review the single prerequisite below, before running.**




Prerequisites:
--------------

To keep this non-interactive (see info above), if you desire any version other than the latest that I have included in the script you must edit **only** the first variable to the desired targeted version.

> NOTE: The desired version must obviously exist.  You can verify at the PowerShell repo releases here as to the **exact** version string you need to provide



# Installation Instructions

Either clone this repo, or simply download the shell script and first make it executable via:
	
```
chmod +x ./Install-PowerShell-on-PhotonOS.sh
```

Execute the script:

```
./Install-PowerShell-on-PhotonOS.sh
```

You should see the following:

```
root@vdocker [ ~ ]# ./Install-PowerShell-on-PhotonOS.sh
Package glibc-i18n is already installed.
Package gzip is already installed.
Package tar is already installed.
Package icu is already installed.
Package less is already installed.
Package unzip is already installed.
Nothing to do.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   623    0   623    0     0   2097      0 --:--:-- --:--:-- --:--:--  2097
100 55.1M  100 55.1M    0     0  20.3M      0  0:00:02  0:00:02 --:--:-- 25.8M
Generating locales...
  en_US.ISO-8859-1... done
  en_US.UTF-8... done
Generation complete.

root@vdocker [ ~ ]#
```

To verify, execute PowerShell (verify correct version):

```
root@vdocker [ ~ ]# pwsh
PowerShell 6.2.3
Copyright (c) Microsoft Corporation. All rights reserved.

https://aka.ms/pscore6-docs
Type 'help' to get help.

root@vdocker [ ~ ]#
```

Verify loaded modules correctly include core modules:

```
PS /root> Get-Module

ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Manifest   6.1.0.0    Microsoft.PowerShell.Management     {Add-Content, Clear-Content, Clear-Ite…
Manifest   6.1.0.0    Microsoft.PowerShell.Utility        {Add-Member, Add-Type, Clear-Variable,…
Script     2.0.0      PSReadLine                          {Get-PSReadLineKeyHandler, Get-PSReadL…

PS /root> 
```

Test a simple PackageManagement/PowerShellGet search of the PSGallery:

```
root@vdocker [ /root ]# pwsh
PowerShell 6.2.3
Copyright (c) Microsoft Corporation. All rights reserved.

https://aka.ms/pscore6-docs
Type 'help' to get help.

PS /root> Find-Module pstwitter

Version              Name                                Repository           Description
-------              ----                                ----------           -----------
1.0.0.2              PSTwitter                           PSGallery            PSTwitter (Twitter…

PS /root> 

```

If desired (**and if you have supported terminal font active**) feel free to test other functions such as the awesome `wttr.in` retrieval:

```
PS /root> $Weather = (iwr "http://wttr.in/waukesha?lang=en&n" -UserAgent "curl" ).Content -split "`n"
PS /root> $Weather
Weather report: waukesha

               Mist
  _ - _ - _ -  60 °F
   _ - _ - _   ↙ 6 mph
  _ - _ - _ -  1 mi
               0.0 in
                        ┌─────────────┐
┌───────────────────────┤  Thu 12 Sep ├───────────────────────┐
│             Noon      └──────┬──────┘      Night            │
├──────────────────────────────┼──────────────────────────────┤
│               Overcast       │  _`/"".-.     Light rain sho…│
│      .--.     66 °F          │   ,\_(   ).   60 °F          │
│   .-(    ).   ← 11-14 mph    │    /(___(__)  ← 9-16 mph     │
│  (___.__)__)  6 mi           │      ‘ ‘ ‘ ‘  4 mi           │
│               0.0 in | 64%   │     ‘ ‘ ‘ ‘   0.2 in | 93%   │
└──────────────────────────────┴──────────────────────────────┘
                        ┌─────────────┐
┌───────────────────────┤  Fri 13 Sep ├───────────────────────┐
│             Noon      └──────┬──────┘      Night            │
├──────────────────────────────┼──────────────────────────────┤
│  _`/"".-.     Patchy rain po…│    \  /       Partly cloudy  │
│   ,\_(   ).   69 °F          │  _ /"".-.     57 °F          │
│    /(___(__)  ↗ 16-20 mph    │    \_(   ).   ↗ 8-17 mph     │
│      ‘ ‘ ‘ ‘  6 mi           │    /(___(__)  6 mi           │
│     ‘ ‘ ‘ ‘   0.0 in | 70%   │               0.0 in | 0%    │
└──────────────────────────────┴──────────────────────────────┘
                        ┌─────────────┐
┌───────────────────────┤  Sat 14 Sep ├───────────────────────┐
│             Noon      └──────┬──────┘      Night            │
├──────────────────────────────┼──────────────────────────────┤
│    \  /       Partly cloudy  │    \  /       Partly cloudy  │
│  _ /"".-.     69 °F          │  _ /"".-.     68 °F          │
│    \_(   ).   ↗ 11-13 mph    │    \_(   ).   ↑ 11-24 mph    │
│    /(___(__)  6 mi           │    /(___(__)  6 mi           │
│               0.0 in | 0%    │               0.0 in | 0%    │
└──────────────────────────────┴──────────────────────────────┘
Location: Waukesha, Waukesha County, Wisconsin, USA [43.0116784,-88.2314813]

Follow @igor_chubin for wttr.in updates

PS /root> 

```


Changelog:
-------------

| Version | Release Date    |    Description                           |
|---------|-----------------|------------------------------------------|
| v1.0.0.1 | 09-12-2019	| Initial release |
| v1.0.0.2 | 09-13-2019	| Updated for PowerShell v6.23 release |



TODO:
-------------

No immediate TODOs but please submit PRs or requests via GH issue and I will update accordingly.


LICENSE:
-------------
Please see the included LICENSE file.  
  
_THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE._  



__Collin Chaffin__
[![Twitter Follow](https://img.shields.io/twitter/follow/collinchaffin.svg?style=social)](https://twitter.com/collinchaffin)



Donations:
-----------------------------

You can support my efforts and every donation is greatly appreciated!  
<a href="https://paypal.me/CollinChaffin"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" alt="[paypal]" /></a>  


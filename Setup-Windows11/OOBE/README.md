# Install Windows 11 without Microsoft Account

> **I wholeheartedly recommend using Microsoft Account! Most reasons people use for avoiding ones are nonsensical.**
>
> The main reason why I created this guide is that the default user name created during standard setup cannot be set via UI and is fixed to first five characters of e-mail address. Also this is not practical for testing and demo purposes. It is no problem for most home users, but for advanced users like me it is a problem.

## How to

To install Windows 11 without mandatory Microsoft Account, do the following:

1. Boot from installation media and go trough the first part of setup (the oldschool looking like Windows 7).
2. After reboot, wait until it will show the OOBE (Out Of Box Experience, the modern looking interface, asking for country selection).
3. Press `Shift + F10`.
4. Enter the following two commands:
```
curl -L -o bypass.cmd https://altair.is/win11-oobe
bypass.cmd
```
5. The computer will reboot and the setup will continue as usual. You would not be asked to use Microsoft Account, but will be asked for local account name and optional password instead. No other aspect of setup will be changed.

## Will it work?

It should. While the older methods Microsoft removes access to are undocumented hacks, the `unattend.xml` answer file is officially documented and crucial for many real world scenarios. As it will break many deployments, it's highly unlikely to be removed or changed.

## Can I trust you?

No. You should not trust strangers, and especially not weird sociopathic warlocks of the silicon gods like me. Running random scripts from the Internet during critical part of operating system setup is a _very bad idea_ that can lead to entire system compromise.

What you should do instead?

1. Verify that the `https://altair.is/win11-oobe` shortlink is leading to file `bypass.cmd` here.
2. Verify content of the file.
3. Verify content of `unattend.xml` it downloads.

But now, I can't force you to do that, can I? But if you would not do it, you should be whipped! Yeah, I'm into BDSM as well...

## Additional resources

* [Unattended Windows Setup Reference](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/) by Microsoft (official reference documentation)
* [Generate autounattend.xml files for Windows 10/11](https://schneegans.de/windows/unattend-generator/) by Christoph Schneegans (online tool for generating answer files)
* [Bypass NRO](https://github.com/ChrisTitusTech/bypassnro/) by Chris Titus (far more extensive tweaks that inspired me)

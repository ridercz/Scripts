# Install Windows 11 without a Microsoft account.

> **I wholeheartedly recommend using a Microsoft account! The reasons most people give for avoiding them are nonsensical.**
>
> The main reason I created this guide is that the username created during standard setup cannot be set via the UI and is fixed to the first five characters of the email address. This is also not practical for testing and demo purposes. This is not a problem for most home users, but it is for advanced users like me.

## How to

To install Windows 11 without a Microsoft account, follow these steps:

1. Boot from the installation media and complete the initial setup process (it looks like Windows 7).
2. After rebooting, wait until the OOBE (Out of Box Experience) interface appears. This is the modern-looking interface that asks you to select your country.
3. Press _Shift + F10_.
4. Command prompt window will open.
5. Run the following two commands:
```
curl -L -o bypass.cmd https://altair.is/win11-oobe
bypass.cmd
```
6. The computer will reboot and setup will continue as usual. You will not be asked to use a Microsoft account, but will instead be asked for a local account name and optional password. No other aspect of the setup will be changed.

## Will it work?

It should. While the older methods that Microsoft is removing access to are undocumented hacks, the 'unattend.xml' answer file is officially documented and crucial for many real-world scenarios. As breaking it would affect many deployments, it's highly unlikely to be removed or changed.

## Can I trust you?

No, you shouldn't trust strangers, especially not weird, sociopathic warlocks of the silicon god like me. Running random scripts from the Internet during the critical phase of setup of an operating system is a very bad idea that can lead to the entire system being compromised.

You should:

1. Verify that the shortlink https://altair.is/win11-oobe leads to the file `bypass.cmd` here.
2. Verify the content of the file.
3. Verify the content of the 'unattend.xml' file that it downloads.

But I can't force you to do it, can I? If you don't do it, though, you should be whipped! Yes, I'm into BDSM as well. Do you still trust me?

## Additional resources

* [Unattended Windows Setup Reference](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/) by Microsoft (official reference documentation)
* [Generate autounattend.xml files for Windows 10/11](https://schneegans.de/windows/unattend-generator/) by Christoph Schneegans (online tool for generating answer files)
* [Bypass NRO](https://github.com/ChrisTitusTech/bypassnro/) by Chris Titus (far more extensive tweaks that inspired me)


## AAAI Finland Tampere Debugging Log

### 1. Flashing Bela to the latest firmware

Some Bela boards just went wrong. We can enter the IDE but cannot run any patch, even the examples.

It was very likely to be caused by updating a Bela with old firmware from the IDE directly.

In the IDE console, we can run ```grep v0 /etc/motd``` to check the image version.

The firmware of our Bela in the lab is indeed very old, as shown below: 
```
root@bela ~/Bela# grep v0 /etc/motd
Bela release image, v0.1.1, 24 October 2016
```
```  
root@bela ~/Bela# grep v0 /etc/motd
Bela release image, v0.2.1, 24 August 2017
```
So we need to flash the latest firmware to the SD card, instructed by the link: [Manage your SD card](https://github.com/BelaPlatform/Bela/wiki/Manage-your-SD-card]).

After flashing the SD card, sometimes the Bela may not boot from the SD card where we just flash the latest firmware.

On the above link, we choose to use Option 3 to boot from the SD card as the jumper slots in Option 1 are occupied and Option 2 just doesn't work.

After booting from the SD card, we run
```
/opt/Bela/bela_flash_emmc.sh
``` 
to copy the firmware to the BeagleBone internal eMMC.

Actually, now we should be able to get rid of the SD card. But if we do want Bela to boot from the SD card, we can run

```
/opt/Bela/bela_bootloader.sh
```

### 2. Some takeaways when working with PD in Bela

- Better to use abstractions, not sub-patches (the object starting with "pd").
- For audio abstractions, end the file name with a "~", e.g. ```some_audio_object~.pd```.
- The CPU usage can make it hard to connect to the Bela IDE. If so, try to find the solution in [Recover from stuck in reboot loop](https://github.com/BelaPlatform/Bela/wiki/Recover-from-stuck-in-reboot-loop). In short, we find it effective to run ```ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1200 root@192.168.7.2 make -C Bela stop```.
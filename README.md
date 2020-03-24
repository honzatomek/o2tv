# o2tv
# https://blog.vpetkov.net/2019/07/12/netflix-and-spotify-on-a-raspberry-pi-4-with-latest-default-chromium/

Netflix and Spotify on a Raspberry Pi 4 with Latest Default Chromium
by Ventz ⋅ 181 Comments
UPDATE: 3-8-2020 – EVERYTHING WORKS AGAIN!

Chromium has made substantial changes the way libwidevine (and a few major things around DRM) are loaded/used/etc. They have also made changes to the setting and reading of the user-agent propagation. For some time (~2 months or so) — the combination of this badly broke Netflix. It seems they have undone the lib loading in the last couple of versions, and user @Spartacuss discovered the user-agent fix.

The instructions here (as of 3-8-2020) work for: Netflix, Hulu, Hulu, Disney+, Spotify, and many others.

The Raspberry Pi 4 model with 4GB of RAM is the first cheap hardware that can provide a real “desktop-like” experience when browsing the web/watching Netflix/etc. However, if you have tried to run Netflix on the Pi, you have quickly entered the disgusting mess that exists around DRM, WideVine (Netflix being one example of something that needs it), and Chromium.

After hours and hours of effort, I finally discovered a quick and elegant solution that lets you use the latest default provided Chromium browser, without having to recompile anything in order to watch any WideVine/DRM (Netflix, Spotify, etc) content.

Background and the DRM Problem
If you are not familiar with this, the short version is that Netflix (and many others, ex: Spotify) use the WideVine “Content Protection System” – aka DRM, and if you want to watch Netflix or something else that uses it, you need to have a WideVine plugin+browse supported integration. Chrome, Firefox, and Safari make it available for x86/amd64 systems, but not for ARM since technically they don’t have ARM builds.

Chromium, the project Chrome is based on, does have an ARM build, but it does not include any DRM support, and technically it does not include widevine support by default (*caveat here, which helps us later)
So long story short, the question becomes “how do you enable DRM/WideVine support in Chromium?”.

It seems there are two main solutions out there: use an old (v51, 55, 56, 60) version of Chromium which has been “patched” with widevine support (kusti8’s version seems to be the most popular one – except since the new Netflix changes, that also does not work), which requires uninstalling the latest Chromium available, installing the old/patched one, and dropping in older widevine plugins; the second option is to use Vivaldi – a proprietary fork of Opera which also has been “sort of patched”, but it still needs a valid libwidevinecdm plugin (see bellow) and it has it’s own issues (and also…it’s Opera…in 2019…who uses Opera?)

After a lot of research and trial and error, I discovered a much more elegant solution – use the extracted ChromeOS (armv7l – yay) binaries and insert them into Chromium + make everything think it’s ChromeOS (user agent)

Netflix/Hulu/Spotify with the Default Raspberry Pi Chromium Browser

0.) Open Chromium and clear your browser history + cookies. Otherwise it will cache the “failed” DRM components.

1.) Download the latest extracted ChromeOS libwidevine (http://blog.vpetkov.net/wp-content/uploads/2019/08/libwidevinecdm.so_.zip) binary and extract it:

$ sudo su
# cd /usr/lib/chromium-browser
# wget http://blog.vpetkov.net/wp-content/uploads/2019/09/libwidevinecdm.so_.zip
# unzip libwidevinecdm.so_.zip && chmod 755 libwidevinecdm.so
# wget http://blog.vpetkov.net/wp-content/uploads/2020/03/chromeos-browser.desktop.zip
# unzip chromeos-browser.desktop.zip && mv chromeos-browser.desktop /usr/share/applications
 
NOTE: Credit and thanks to @Spartacuss for discovering user-agent method with .desktop file!

NOTE: You can verify that these are the *official* versions from ChromeOS:
https://dl.google.com/dl/edgedl/chromeos/recovery/chromeos_12239.92.0_elm_recovery_stable-channel_mp-v2.bin.zip

NOTE: UPDATED (Last re-extracted from ChromeOS on: 9-8-19)
filename: libwidevinecdm.so
md5sum: 41c94b9ffa735fe4f412b7e9283dd2ff
sha256sum: 2245a2f5ba8452692e79f478d64adbeedaef5307cc73e81ffe64de69a7a53640

2.) Completely QUIT all Chromium windows.
Start Chromium with new Application Menu item: Chromium (ChromeOS spoofing)
Open a new tab, and go to: https://bitmovin.com/demos/drm
You should be able to see the movie on the left. You can now play Netflix, Hulu, Spotify, Pandora, Disney+, HBO and many others!

Please note that If you can see the video on the left, this means the DRM plugin has worked! From this point on, anything that does not work (ex: Netflix sometimes breaks after a browser update) is due to the site specifically filtering User Agents/doing other “tricks”. So for example, if Netflix does not work, Spotify, Hulu, Amazon, HBO, etc will still work. The BitMovin website is the “real” test on wether the DRM plugin has worked.

Solution if you see occasional “screen tearing”
It seems the Pi’s raw CPU frequency is still not powerful enough for decoding 100% of the time. While 97-98% of the time is good enough, you will get the occasional “screen tearing” (https://en.wikipedia.org/wiki/Screen_tearing), especially with scenes with fast motion.

User Tim (credit to him for finding this!) may have found the solution to this:

Ok think i have a fix. Netflix in Chrome will only play 1280 x 720 max (its a known thing) and can be checked by pressing CTRL SHIFT ALT and D when the video is playing in Netflix (for Vid stats).
So as a test i changed my pi screen configuration from 1920 x 1080 to 1280 x 720 (at 59.94 HZ) and netflix plays fine with no tearing. (the tearing was mostly present when the camera pans left to right etc). For some reason my monitor has a 1280 x 720 at 60HZ option but this also gave a little tearing, the 59.94Hz option cures it completely, this works for me and i am happy watching Netflix at 720p

Update to this: It seems Netflix will only play at 720p on Chrome, so by lowing the resolution, it removes tearing in the cases where the monitor is at a higher resolution/60Hz.

Older Versions
Here are the last few OLDER versions in case you need them (note the unique date in the url):
http://blog.vpetkov.net/wp-content/uploads/2019/08/libwidevinecdm.so_.zip
http://blog.vpetkov.net/wp-content/uploads/2019/07/libwidevinecdm.so_.zip

# m4s2mp4
> m4s to mp4 converter

[中文说明](README.md)

---

This is an automated script for macOS/Linux terminals. It removes the disguise header (9 bytes of 0) from Bilibili's cached `.m4s` files with a single click, and losslessly merges them into standard high-definition MP4 videos.

## 📁 Dependencies & Directory Structure

Before using, please ensure the file structure in your main directory is as follows:

```text
Your Working Directory/
 ├── ffmpeg            # FFmpeg executable (Required)
 ├── m4s2mp4.sh        # The merging script
 ├── 1201093266/       # Bilibili cache folder (named with numbers)
 │   ├── xxxx_1.m4s    # Video stream file
 │   └── xxxx_2.m4s    # Audio stream file
 ├── 168467103/        # Other cache folders...
```

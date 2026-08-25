# Omacat

A cat that runs faster when your CPU works harder. Inspired by Omacat for Mac.

Remember the cat that ran across your macOS menu bar? Now it lives in your Omarchy bar.

![Omacat](preview.png)
<img width="142" height="128" alt="screenrecording-2026-08-25_21-29-54" src="https://github.com/user-attachments/assets/98c16443-5082-4c72-a1ff-f0a8246c020b" />
## Install

```sh
omarchy plugin add https://github.com/JoeJoeflyn/omacat.git --enable
```

## Usage

The cat runs at a speed proportional to your CPU usage — slow stroll when idle, sprint when busy. Click to open `btop`.

## Configure

```sh
omarchy bar move io.github.joejoeflyn.omacat --section right
```

## Remove

```sh
omarchy plugin remove io.github.joejoeflyn.omacat --yes
```

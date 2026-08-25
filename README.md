# OmaCat

A cat that runs faster when your CPU works harder. Inspired by OmaCat for Mac.

Remember the cat that ran across your macOS menu bar? Now it lives in your Omarchy bar.

![OmaCat](preview.png)

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

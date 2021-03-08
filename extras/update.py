#!/usr/bin/env python

import os
import sys
import logging
import configparser
import xml.etree.ElementTree as ET

xml = "/config/config.xml"
autoProcess = os.path.join(os.environ.get("SMA_PATH", "/usr/local/sma"), "config/autoProcess.ini")


def main():
    safeConfigParser = configparser.ConfigParser()
    safeConfigParser.read(autoProcess)

    # Set FFMPEG/FFProbe Paths
    safeConfigParser.set("Converter", "ffmpeg", "/usr/local/bin/ffmpeg")
    safeConfigParser.set("Converter", "ffprobe", "/usr/local/bin/ffprobe")

    # Set IP from environment variable
    ip = os.environ.get("HOST")
    if ip:
        safeConfigParser.set(section, "host", ip)
    else:
        safeConfigParser.set(section, "host", "127.0.0.1")

    fp = open(autoProcess, "w")
    safeConfigParser.write(fp)
    fp.close()


if __name__ == '__main__':
    main()
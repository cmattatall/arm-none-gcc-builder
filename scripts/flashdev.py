import os
import platform
import argparse

# Example script to flash the target device
# TODO: this comes after the build system is set up and super robust

def flash_windows(target):
    pass
    print("Windows support not yet built into the script")

def flash_linux(target):
    pass
    print("Linux support not yet built into the script")


if __name__ == "__main__":

    host_platform = platform.system()

    if host_platform == 'Windows':
        flash_windows()
    elif host_platform == 'Linux':
        flash_linux()
    else:
        pass
        print("%s support not yet built into the script" % (host_platform))
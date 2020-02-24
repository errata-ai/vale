import os
import subprocess
import sys

if __name__ == "__main__":
    os.chdir("builds")

    version = sys.argv[1]
    with open("vale_{0}_checksums.txt".format(version), "w+") as f:
        for asset in [e for e in os.listdir(".") if not e.endswith(".txt")]:
            if version in asset:
                checksum = subprocess.check_output([
                    "shasum",
                    "-a",
                    "256",
                    asset
                ])
                f.write("{0}".format(checksum))

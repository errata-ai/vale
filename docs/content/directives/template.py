import subprocess
import os

vale = os.path.abspath(os.path.join("..", "docs", "bin", "vale"))


def main(extends):
    """return an example for the given Vale extension point.
    """
    example = subprocess.check_output([vale, "new-rule", extends])
    return example.decode("utf-8").strip()

import subprocess


def main(extends):
    """return an example for the given Vale extension point.
    """
    example = subprocess.check_output(["vale","new", extends])
    return example.decode("ascii").strip()

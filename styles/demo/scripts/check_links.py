import json
import re
import socket
import sys

import urllib.request as request


def is_broken(url):
    """Determine whether the link returns a 404 error."""
    try:
        req = request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        request.urlopen(req).read()
        return False
    except request.URLError:
        return True
    except socket.error:
        return True

# See https://mathiasbynens.be/demo/url-regex
regex = re.compile(r"(?:https?|ftp)://[^\s/$.?#].[^\s>\])]*")
alerts = []
for m in re.finditer(regex, sys.argv[1]):
    url = m.group(0).strip()
    if is_broken(url):
        alerts.append({
            "Check": "demo.CheckLinks",
            "Span": [m.start(), m.end()],
            "Message": "'" + url + "' is broken",
            "Severity": "error"
        })

print(json.dumps(alerts))

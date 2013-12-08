#!/usr/bin/python
import sys
import os
import subprocess

import alfred


def main(query):
    LIST_RUNNING_APPS='./list_running_apps'
    if os.path.isdir(LIST_RUNNING_APPS):
        LIST_RUNNING_APPS='./list_running_apps/build/Release/list_running_apps'
    out, err = subprocess.Popen([LIST_RUNNING_APPS], stdout=subprocess.PIPE).communicate()
    lines = out.splitlines()
    lines.append(lines.pop(0))
    suggested_items = []
    uid = uid_generator()
    for i, bundle_name, bundle_id, pid, bundle_path in [_.split(',') for _ in lines]:
        if not query in bundle_id.lower() and not query in bundle_name:
            continue
        suggested_items.append(alfred.Item(
            attributes = { 'uid': uid.next(), 'arg': bundle_id },
            title = bundle_name.decode('utf-8'), subtitle = bundle_id, 
            icon = [bundle_path, {'type':'fileicon'}]
            ))
    alfred.write(alfred.xml(suggested_items, 30))

def uid_generator():
    import time
    uid = time.time()
    while True:
        uid += 1
        yield uid

if __name__ == '__main__':
    main(' '.join(sys.argv[1:]))


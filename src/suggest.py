#!/usr/bin/python
import sys
import subprocess

import alfred

def main(query):
    out, err = subprocess.Popen(['./list_running_apps'], stdout=subprocess.PIPE).communicate()
    suggested_items = []
    uid = uid_generator()
    for i, bundle_name, bundle_id, pid, bundle_path in [_.split(',') for _ in out.splitlines()]:
        if not query in bundle_id.lower() and not query in bundle_name:
            continue
        suggested_items.append(alfred.Item(
            attributes = { 'uid': uid.next(), 'arg': pid },
            title = bundle_name.decode('utf-8'), subtitle = bundle_id, 
            icon = [bundle_path, {'type':'fileicon'}]
            ))
    alfred.write(alfred.xml(suggested_items))

def uid_generator():
    import time
    uid = time.time()
    while True:
        uid += 1
        yield uid

if __name__ == '__main__':
    main(' '.join(sys.argv[1:]))


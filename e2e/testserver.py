#!/usr/bin/env python

import json
import SimpleHTTPServer
import re
import os
import os.path as path
import posixpath
import urllib


item_pat = re.compile("/api/([^ ?]+)/([^ ?]+)/?(\?.*)?")
list_pat = re.compile("/api/([^ ?]+)/?(\?.*)?")


restarting = True
running = True
data = {}


def item_resp(x):
    return json.dumps({"_status":"OK","_item":x})

def list_resp(xs):
    return json.dumps({"_status":"OK","_items":xs})


class Handler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        global data
        
        if self.path.startswith("/_"):
            globals()[self.path[2:]]()
            self.send_response(204)
            return
        elif item_pat.match(self.path):
            coll, _id, params = item_pat.match(self.path).groups()
            _id = int(_id)
            self.send_response(200)
            self.send_header("Content-type", 'application/json')
            self.end_headers()
            item = filter(lambda x: x['_id']==_id, data[coll])[0]
            self.wfile.write(item_resp(item))
            return
        elif list_pat.match(self.path):
            coll, params = list_pat.match(self.path).groups()
            self.send_response(200)
            self.send_header("Content-type", 'application/json')
            self.end_headers()
            self.wfile.write(list_resp(data[coll]))
            return
        else:
            SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)


    def do_POST(self):
        global data
        
        if list_pat.match(self.path):
            coll, = list_pat.match(self.path).groups()
            
            try:
                l = int(self.headers.getheader('Content-Length'))
                inc = json.loads(self.rfile.read(l))
            except:
                self.send_response(400)
                return
            
            ids = [x['_id'] for x in data[coll]]
            inc['_id'] = max(ids)+1
            data[coll].append(inc)
            
            self.send_response(201)
            self.send_header("Content-Type", 'application/json')
            self.end_headers()
            self.wfile.write(item_resp(inc))
            return
        else:
            SimpleHTTPServer.SimpleHTTPRequestHandler.do_POST(self)


    def do_PUT(self):
        global data
        
        if item_pat.match(self.path):
            coll, _id = item_pat.match(self.path).groups()
            _id = int(_id)
            
            try:
                l = int(self.headers.getheader('Content-Length'))
                inc = json.loads(self.rfile.read(l))
            except:
                self.send_response(400)
                return
            
            ids = [x['_id'] for x in data[coll]]
            inc['_id'] = _id
            data[coll][ids.index(_id)] = inc
            
            self.send_response(200)
            self.send_header("Content-Type", 'application/json')
            self.end_headers()
            self.wfile.write(item_resp(inc))
            return
        else:
            SimpleHTTPServer.SimpleHTTPRequestHandler.do_PUT(self)


    def do_DELETE(self):
        global data
        
        if item_pat.match(self.path):
            coll, _id = item_pat.match(self.path).groups()
            _id = int(_id)
                        
            ids = [x['_id'] for x in data[coll]]
            data[coll].pop(ids.index(_id))
            
            self.send_response(204)
            return
        else:
            SimpleHTTPServer.SimpleHTTPRequestHandler.do_DELETE(self)
    
    

def end():
    global restarting
    global running
    restarting = False
    running = False

def restart():
    global running
    running = False

def reset():
    global data
    data = json.load(open(path.join(path.dirname(__file__),'init_data.json')))

def run_while_true():
    global restarting
    global running

    while restarting:
        reset()
        httpd = SimpleHTTPServer.BaseHTTPServer.HTTPServer(('', 8000), Handler)
        sa = httpd.socket.getsockname()
        print "Serving HTTP on", sa[0], "port", sa[1], "..."
    
        running = True
        while running:
            try:
                httpd.handle_request()
            except:
                raise


if __name__ == '__main__':
    run_while_true()

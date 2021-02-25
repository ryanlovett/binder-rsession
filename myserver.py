#!/usr/bin/env python
# Reflects the requests from HTTP methods GET, POST, PUT, and DELETE
# Written by Nathan Hamiel (2010)
# Adapted by huyng, 1kastner, and ryanlovett at github
# https://gist.github.com/1kastner/e083f9e813c0464e6a2ec8910553e632

import logging
import sys

from http.server import HTTPServer, BaseHTTPRequestHandler
from optparse import OptionParser

logging.basicConfig(
    level=logging.DEBUG,
    handlers=[
        logging.FileHandler(filename='/tmp/myserver.log'),
        logging.StreamHandler(stream=sys.stderr)
    ]
)
mylogger = logging.getLogger('mylogger')
mylogger.setLevel(logging.DEBUG)
mylogger.debug("this is a debugging message.")

class RequestHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        
        request_path = self.path
        
        mylogger.info("\n----- Request Start ----->\n")
        mylogger.info(f"Request path: {request_path}")
        mylogger.info(f"Request headers: {self.headers}")
        mylogger.info("<----- Request End -----\n")
        
        self.send_response(200)
        self.send_header("Set-Cookie", "foo=bar")
        self.end_headers()
        
    def do_POST(self):
        
        request_path = self.path
        
        mylogger.info("\n----- Request Start ----->\n")
        mylogger.info(f"Request path:", request_path)
        
        request_headers = self.headers
        content_length = request_headers.get('Content-Length')
        length = int(content_length) if content_length else 0
        
        mylogger.info(f"Content Length: {length}")
        mylogger.info(f"Request headers: {self.headers}")
        mylogger.info(f"Request payload: {self.rfile.read(length)}")
        mylogger.info("<----- Request End -----\n")
        
        self.send_response(200)
        self.end_headers()
    
    do_PUT = do_POST
    do_DELETE = do_GET
        
def main():
    port = 9000
    mylogger.info('Listening on 0.0.0.0:%s' % port)
    server = HTTPServer(('', port), RequestHandler)
    server.serve_forever()

        
if __name__ == "__main__":
    parser = OptionParser()
    parser.usage = ("Creates an http-server that will echo out any GET or POST parameters\n"
                    "Run:\n\n"
                    "   reflect")
    (options, args) = parser.parse_args()
    
    main()

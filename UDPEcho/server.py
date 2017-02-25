#! /usr/bin/env python

import socket 
import sys

ECHO_PORT = 50000
BUFFSIZE = 1024

def server():
	port = ECHO_PORT
	print ("trying to open socket")
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.bind(('', port))
	print "udp echo server ready"
	while 1:
		data, addr = s.recvfrom(BUFFSIZE)
		print 'server received %r from %r' % (data, addr)
		s.sendto(data, addr)

server()
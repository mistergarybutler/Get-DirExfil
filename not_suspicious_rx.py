#!/usr/bin/python

import os, sys, socket, random

randomInt = random.random()
filename = "a" + str(random).split(".")[1] + ".loot"
fd = open(filename, "w")

if(len(sys.argv != 4):
	print "Please supply args: rhost rport buffersize"
	sys.exit()
	
rhost = sys.argv[1]
rport = int(sys.argv[2])
buf = int(sys.argv[3])

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((rhost, rport))
s.listen(1)
while True:
	connection, address = s.accept()
	
	result = connection.recv(buf + 3)
	while result != '':
		result = connection.recv(buf + 3)
		if(len(result) == buf + 3):
			s.close()
			fd.close()
			sys.exit()
		elif(len(result) <= buf):
			f.write(result)

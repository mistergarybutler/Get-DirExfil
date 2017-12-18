#!/usr/bin/python

import os, sys, socket, random

randomInt = random.random()
filename = "a" + str(randomInt).split(".")[1] + ".loot"
fd = open(filename, "w")

if(len(sys.argv) != 4):
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
	print type(connection)
	print address
	
	count=0
	bytes=0	
	result = ' '
	while result != '':
		result = connection.recv(buf + 100)

		if(len(result) == buf + 3):
			print len(result)
			s.close()
			fd.close()
			sys.exit()
		elif(len(result) <= buf):
			fd.write(result)
#			count+=1
#			bytes+=len(result)
#			print "Data packet: " + str(count) + " Bytes: " + str(bytes)

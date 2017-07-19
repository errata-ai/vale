.PHONY : test
test :
	go test -v

.PHONY : gdb
gdb :
	go test -c -s -N -l
	gdb ./tests.test

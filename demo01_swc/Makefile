
T01: check
	@echo "-------- Sample 1 --------"
#	@echo "Compiling C EXE ..."
#	"$(FLASCC)/usr/bin/gcc" $(BASE_CFLAGS) YRMCl-20171121.c drmt_func.c main.c -o hello.exe
	@echo "Compiling C SWC and demo SWF (Debug) "
	"$(FLASCC)/usr/bin/gcc" $(BASE_CFLAGS) -g -O0 demo_func.c main.c -emit-swc=kevin.democ -o democ.swc 
	"$(FLASCC)/usr/bin/gcc" $(BASE_CFLAGS) -g -O0 demo_func.c demo_test.c -emit-swf -o demo.swf 


include ./Makefile.common

clean:
	rm -f  *.swf *.bc *.o *.exe *.txt *.i *.ii

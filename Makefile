ASM = acme
AFLAGS = -f "cbm"

SOURCES = common/common.a maths/multiply8bit.a

tests: tests/tests.a $(SOURCES)
	$(ASM) $(AFLAGS) -o bin/tests.prg tests/tests.a
	
clean:
	rm -f bin/*.prg

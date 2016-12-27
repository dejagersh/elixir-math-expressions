all:
	make clean
	elixirc *.ex

clean:
	rm -f *.beam

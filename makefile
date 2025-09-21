.PHONY: all clean
all:
	$(MAKE) -C src

clean:
	$(MAKE) -C src clean
	rm -rf  obj sample_input.txt


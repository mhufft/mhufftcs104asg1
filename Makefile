#Author: Carl Eadler
#partner: Max Hufft

# For self-reference:
# $< is code for using a variable source file
# $@ is code for using a variable target file

sources = stringset.cpp auxlib.cpp main.cpp
objects = stringset.o   auxlib.o   main.o
headers = stringset.h   auxlib.h      
extra   = Makefile README .gitignore PARTNER
output = oc
dir = $(shell pwd)
gitaddress = https://github.com/mhufft/mhufftcs104asg1.git
gitproject = mhufftcs104asg1

sampleParameter = auxlib.h

#The following code make a macro for \n to be replaced by the newline character
define \n


endef

all: compile

compile: $(objects)
	g++ -g -Wall -Wextra -o $(output) -std=gnu++11  $(objects)

%.o: %.cpp
	g++ -c -std=gnu++11 -o $@ $<

spotless: clean
	rm "$(dir)/$(output)"

clean:
	$(foreach var,$(objects),rm -f "$(dir)/$(var)"${\n})

run: $(output)
	$(output) $(sampleParameter)


clear:
	clear

ci: gitpush

gitinit:
	git init
	git remote add origin $(gitaddress)

gitclone:
	rm -rf $(gitproject)
	git clone $(gitaddress)

gitpush:
	git add $(sources) $(headers) $(extra)
	git commit --untracked-files=no
	git push origin master

gitpull:
	#mv Makefile Makefile.bak
	git pull -f $(gitaddress) master

deps:
	echo ""
   
space:
	@for unused in 1 2 3 4 5; do echo "*"; done

everything: clear space clean compile run

everythingit: everything gitpush

submit: $(sources) $(headers) $(extra)
	submit cmps104a-wm.f14 asg1 $(sources) $(headers) $(extra)

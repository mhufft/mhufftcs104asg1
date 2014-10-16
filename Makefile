#Author: Carl Eadler
#partner: Max Hufft

# For self-reference:
# $< is code for using a variable source file
# $@ is code for using a variable target file

sources = stringset.cpp main.cpp
headers = stringset.h
extra   = Makefile README .gitignore
objects = main.o stringset.o
output = oc
dir = $(shell pwd)
gitaddress = https://github.com/mhufft/mhufftcs104asg1.git
gitproject = mhufftcs104asg1

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
	$(output)


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
	git commit -q
	git push origin master

gitpull:
	#mv Makefile Makefile.bak
	git pull -f $(gitaddress) master

deps:
	echo "Idk what to do yet"

everything: clear clean compile run

everythingit: everything gitpush

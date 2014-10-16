#Author: Carl Eadler
#partner: Max Hufft

# For self-reference:
# $< is code for using a variable source file
# $@ is code for using a variable target file

sources = stringset.cpp main.cpp 
headers = stringset.h
extra   = Makefile README
objects = main.o
output = oc
dir = $(pwd)
gitaddress = https://github.com/mhufft/mhufftcs104asg1.git

all: compile

compile: $(objects)
	g++ -g -Wall -Wextra -o $(output) -std=gnu++11  $(objects)

%.o: %.cpp
	g++ -c -std=gnu++11 -o $@ $<

spotless: clean
	rm "$(dir)/$(output)"

clean:
	$(foreach var,$(objects),"rm $(dir)/$(var)")

run: $(output)
	$(output)


clear:
	clear

ci: gitpush

gitinit:
	git init
	git remote add origin $(gitaddress)

gitclone:
	git clone $(gitaddress)

gitpush:
	git add $(sources) $(headers) $(extra)
	git commit
	git push origin master

gitpull:
	git pull $(gitaddress) master

deps:
	echo "Idk what to do yet"

everything: clear clean compile run

everythingit: everything gitpush

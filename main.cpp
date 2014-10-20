//Authors: Carl Eadler (ceadler@ucsc.edu), Max Hufft (mhufft@ucsc.edu)
//Starter code provided with permission by Wesley Mackey

#include "stringset.h"
//#include "auxlib.h"

#include <cstdio>
#include <unistd.h>
#include <iostream>
#include <string>
#include <cstring>
#include <vector>

using namespace std;

const string cpp_exe = "/usr/bin/cpp";
string cpp_command = "";

FILE* oc_file = nullptr;


void cpp_popen(string filename)
{
   cpp_command =  cpp_exe;
   cpp_command += " ";
   cpp_command += filename;
   oc_file = popen(cpp_command.c_str(), "r");
   if (oc_file == nullptr)
   {
      cerr << "Could not open file: " << filename << endl;
      exit(EXIT_FAILURE);
   }
}



void cpp_pclose(void)
{
   int pclose_status = pclose(oc_file);
   if (pclose_status != 0)
   {
      exit(EXIT_FAILURE);
   }
}


void insert_define(string definition)
{
}


void scan_options(int argc, char** argv)
{
   int option;
   while(true) {
      option = getopt (argc, argv, "@:D:ly");
      if (option == EOF) break;
      switch (option) {
         case '@': set_debugflags (optarg);   break;
         case 'D': insert_define  (optarg);   break;
         case 'l': /*yy_flex_debug = 1;    */ break;
         case 'y': /*yydebug = 1;          */ break;
         default:
         {
            cerr << "Bad option: \'" << optopt << "\'"<< endl;
            break;
         }
      }
   }
   if (optind > argc) 
   {
      cerr << "Usage: " << get_execname() << " [-@:D:ly] [filename]" << endl;
      exit (get_exitstatus());
   }
   const char* filename = (optind == argc ? "-" : argv[optind]);
   cpp_popen (filename);
   DEBUGF ('m', "filename = %s, oc_file = %p, fileno (oc_file) = %d\n",
           filename, oc_file, fileno (oc_file));
}


void tokenize(char* str, vector<string>& tokenVector)
{
   tokenVector.clear();
   char* tok;
   tok = strtok(str, " ");
   while(tok != NULL)
   {
      tokenVector.push_back(string(tok));
      tok = strtok(NULL, " .,-");
   }
}

void process_tokens(vector<string> tokens)
{
   for(auto str = tokens.begin(); str != tokens.end(); str++)
   {
      intern_stringset((*str).c_str());
   }
}

void process_file(void)
{
   
   if(oc_file != nullptr)
   {
   char buf[1024];
   if(fgets(buf, 1024, oc_file) != nullptr)
   {
      vector<string> tokens;
      while(!feof(oc_file))
      {
         //cerr << buf;
         tokenize(buf, tokens);
         process_tokens(tokens);
         fgets(buf, 1024, oc_file);
         //cerr<<"!";
      }
   }
}
}

int main (int argc, char** argv)
{
   scan_options(argc, argv);
   process_file();
   FILE* outt = fopen("something.txt", "w");
   dump_stringset(outt);
   return EXIT_SUCCESS;
}

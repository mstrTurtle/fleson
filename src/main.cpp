#include <iostream>
#include <cstdlib>
#include <cstring>
#include <cassert>

#include "tm_driver.h"

int main( const int argc, const char **argv )
{
    /** check for the right # of arguments **/
    if(argc != 2){
        std::cout << "only allow 1 arg.\n";
        return ( EXIT_FAILURE );
    }

    turtle::Driver driver;
    if( std::strncmp(argv[1],"-o",2) == 0 ){
        driver.parse( std::cin );
    }else if(std::strncmp(argv[1],"-h",2) == 0){
        std::cout << "use -o for pipe to std::cin\n";
        std::cout << "just give a filename to count from a file\n";
        std::cout << "use -h to get this menu\n";
        return( EXIT_SUCCESS );
    }else{
        const char* &file = argv[1];
        driver.parse(file);
    }
    driver.print_info(std::cout) << "\n";

   return( EXIT_SUCCESS );
}

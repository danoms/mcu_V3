/*
 * GccApplication1.c
 *
 * Created: 08.06.2017 15:13:47
 * Author : User
 */ 

#include <avr/io.h>


int main(void)
{
   volatile unsigned int a,b,c;
   a = 200;
   b = 145;
   c = 0;
    while (1) 
    {
		if (c != 0)
		{
			c--;
		} 
		else
		{
			c = a + b;
		}
		
    }
}


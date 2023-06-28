#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int n, s, i, j;
    do
    {
        n = get_int("Height: ");
    }
    while (n < 1 || n > 8);

    //i for row
    for (i = 0; i < n; i++)
    {
        //s for space
        for (s = 0; s < n - i - 1; s++)
        {
            printf(" ");
        }
        //j for column
        for (j = 0; j <= i; j++)
        {

            printf("#");
        }
        //for space between pyramid
        printf("  ");
        //for second pyramid
        for (j = 0; j <= i; j++)
        {
            printf("#");
        }
    printf("\n");
    }
}
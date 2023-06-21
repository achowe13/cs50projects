#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int main(int argc, string argv[])
{
    // in case no command line input
    if (argc != 2)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    //checks if all values in key(argv[1]) are digits
    for (int i = 0; i < strlen(argv[1]); i++)
    {
        if (!isdigit(argv[1][i]))
        {
            printf("Usage: ./caesar key\n");
            return 1;
        }
    }

    // p is plain text or unencrypted text
    string p = get_string("Plaintext:  ");

    // k is intiger form of input key(argv[1])
    int k = atoi(argv[1]);

    printf("ciphertext: ");

    // encrypt text and print encrypted text
    for (int j = 0; j < strlen(p); j++)
    {
        if (isupper(p[j]))
        {
            printf("%c", (p[j] - 65 + k) % 26 + 65);
        }
        else if (islower(p[j]))
        {
            printf("%c", (p[j] - 97 + k) % 26 + 97);
        }
        else if (!isalpha(p[j]))
        {
            printf("%c", p[j]);
        }
        else
        {
            return 0;
        }
    }
    printf("\n");
}
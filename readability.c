#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

int main(void)
{
    //initialize letters, words and sentences variables
    int l = 0;
    int w = 1;
    int s = 0;

    //get string from user
    string text = get_string("enter text: \n");

    //count letters, words, and sentences
    for (int i = 0; i < strlen(text); i++)
    {
        if (isalpha(text[i]))
        {
            l++;
        }
        else if (text[i] == ' ')
        {
            w++;
        }
        else if (text[i] == '.' || text[i] == '?' || text[i] == '!')
        {
            s++;
        }
    }
    //calculate grade level
    float L = (float)l / (float)w * 100;
    float S = (float)s / (float)w * 100;

    int gl = round(0.0588 * L - 0.296 * S - 15.8);

    //print grade
    if (gl > 16)
    {
        printf("Grade 16+\n");
    }
    else if (gl < 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade %i\n", gl);
    }
}
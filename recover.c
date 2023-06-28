#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef uint8_t BYTE;

int main(int argc, char *argv[])
{
    //makes sure there is only one command line argument
    if (argc != 2)
    {
        printf("Only 1 command line argument please!\n");
        return 1;
    }

    //opens file
    FILE *input_ptr = fopen(argv[1], "r");

    //makes sure file is valid
    if (input_ptr == NULL)
    {
        printf("Could not open this file.\n");
        return 1;
    }

    //create needed variables
    BYTE buffer[512];
    int counter = 0;
    FILE *jpeg_ptr = NULL;
    char filename[8];

    //read program in 512 byte chunks as per FAT file
    while (fread(&buffer, sizeof(BYTE), 512, input_ptr) != 0)
    {
        //check if first 4 bytes are correct allowing for changes in final variable
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff && (buffer[3] & 0xf0) == 0xe0)
        {
            if (counter != 0)
            {
                fclose(jpeg_ptr);
            }
            //assign name for filename based on counter
            sprintf(filename, "%03i.jpg", counter);

            jpeg_ptr = fopen(filename, "w");

            counter++;
        }
        //if block is part of jpeg write it to opened file
        if (counter != 0)
        {
            fwrite(&buffer, sizeof(BYTE), 512, jpeg_ptr);
        }
    }
    //if finished with jpeg close file
    if (counter != 0)
    {
        fclose(jpeg_ptr);
    }
    //close original file and end program
    fclose(input_ptr);
    return 0;
}
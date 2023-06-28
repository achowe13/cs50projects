from cs50 import get_int


def main():

    # get height function defined later
    height = get_height()

    # i for height of columbs
    for i in range(height):

        # s to add spaces befor first block creating right alligned pyramid
        for s in range(height - i - 1):
            print(" ", end="")

        # j for width of pyramid based on height (this is for the first pyramid)
        for j in range(i + 1):
            print("#", end="")

        print("  ", end="")
        # j for width of pyramid based on height (pyramid 2)
        for j in range(i + 1):
            print("#", end="")

        # for new line when done with entire row
        print()


def get_height():

    while True:

        # This Gets an int called height from the user
        height = get_int("Height: ")

        # This makes sure that the height int is between 1 and 8
        if (height > 0) and (height < 9):
            break

    return height


main()
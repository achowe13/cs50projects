import csv
import sys


def main():

    # Check for command-line usage
    if not len(sys.argv) == 3:
        print("2 command line arguments required")
        sys.exit()

    # open and read database file into a dictionary list called database_list
    with open(sys.argv[1], "r") as database:
        dbreader = csv.DictReader(database)
        database_list = list(dbreader)

    # Read DNA sequence file into a variable called sequence
    with open(sys.argv[2], "r") as dna:
        sequence = dna.read()

    # create list of just STRs to make comparisons easy
    STRs = dbreader.fieldnames[1:]

    # find max number of repeats in dna .txt file
    max_repeats = {}
    for STR in STRs:
        max_repeats[STR] = longest_match(sequence, STR)

    # print(max_repeats)
    # create counter to compare to total number of STRs to see if correct person is found
    counter = 0

    # go through each person in database and see if each their max values match
    for person in database_list:
        for STR in STRs:
            if max_repeats[STR] == int(person[STR]):
                counter += 1
        # if total number of STRs is the same as the counter then all STRs match so print name of matching person.
        if counter == len(STRs):
            print(f"{person['name']}")
            sys.exit()
        counter = 0

    print("No match")
    sys.exit


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()

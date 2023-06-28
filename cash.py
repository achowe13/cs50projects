from cs50 import get_float


def main():

    # get dollar amount and convert into cents
    cents = get_cents()

    # calculate quarters and update cents
    qtr = calculate_quarters(cents)
    cents = cents - (qtr * 25)

    # calculate dimes and update cents
    dime = calculate_dimes(cents)
    cents = cents - dime * 10

    # calculate nickels and update cents
    nic = calculate_nickels(cents)
    cents = cents - nic * 5

    # calculate pennies and update cents
    pen = calculate_pennies(cents)
    cents = cents - pen

    # calculate total coins
    coins = qtr + dime + nic + pen

    print(f"{coins}")


def get_cents():

    while True:
        cash = get_float("Change owed: ")
        if cash > 0:
            break

    cents = cash * 100
    return int(cents)


def calculate_quarters(cents):

    qtr = 0

    while cents >= 25:
        cents -= 25
        qtr += 1

    return qtr


def calculate_dimes(cents):

    dime = 0

    while cents >= 10:
        cents -= 10
        dime += 1

    return dime


def calculate_nickels(cents):

    nic = 0

    while cents >= 5:
        cents -= 5
        nic += 1

    return nic


def calculate_pennies(cents):

    pen = 0

    while cents >= 1:
        cents -= 1
        pen += 1

    return pen


main()
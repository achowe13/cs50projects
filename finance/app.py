import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    # sql query to get users stocks
    stocks = db.execute("SELECT symbol, shares, name FROM stocks WHERE user_id = ?", session["user_id"])

    # sql query to get users current cash
    cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])[0]["cash"]

    # ensure stock returns values
    if len(stocks) > 0:
        porfolio = 0
        for stock in stocks:
            price = lookup(stock["symbol"])["price"]
            total = stock["shares"] * price
            porfolio += total
            stock.update({"price": usd(price), "total": usd(total)})
        porfolio = usd(cash + porfolio)
        options = db.execute("SELECT symbol FROM stocks where user_id = ?", session["user_id"])
        return render_template("index.html", stocks=stocks, cash=usd(cash), total=total, price=price, porfolio=porfolio, options=options)

    # if user does not own any stock
    else:
        return render_template("index.html", cash=usd(cash))


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":

        # ensures form was entered correctly
        if not request.form.get("symbol"):
            return apology("stock symbol needed", 400)
        elif not request.form.get("shares"):
            return apology("number of shares required", 400)
        elif request.form.get("shares").isnumeric() == False:
            return apology("invalid entry for shares",400)
        else:
            # create variables for everything needed to buy stocks
            symbol = request.form.get("symbol").upper()
            shares = int(request.form.get("shares"))
            stock = lookup(symbol)

            # make sure valid stock symbol was entered
            if not stock:
                return apology("invalid stock", 400)

            name = stock["name"]
            price = stock["price"]
            user_id = session["user_id"]
            cash = db.execute("SELECT cash FROM users WHERE id = ?", user_id)[0]["cash"]

            # if user doesn't have sufficient funds to purchace return apology
            remaining_cash = cash - (price * shares)

            if remaining_cash < 0:
                return apology("insufficient funds!", 403)

            # check if this stock is already owned by the user
            repeat_stock = db.execute("SELECT symbol FROM stocks WHERE symbol = ? and user_id = ?", symbol, user_id)
            total_cost = price * shares

            if len(repeat_stock) > 0:
                current_shares = db.execute("SELECT shares FROM stocks WHERE symbol = ? and user_id = ?", symbol, user_id)[0]["shares"]
                total_shares = shares + current_shares
                db.execute("UPDATE stocks SET shares = ? WHERE symbol = ? AND user_id = ?", total_shares, symbol, user_id)
                db.execute("UPDATE users SET cash = ? WHERE id = ?", remaining_cash, user_id)
                db.execute("INSERT INTO history (symbol, price, shares, type, user_id, name, total) VALUES(?, ?, ?, ?, ?, ?, ?)", symbol, price, shares, "Buy", user_id, name, total_cost)

                return redirect("/")

            # enter stock into table and lower cash by total price of stock purchased and return to home page after purchase
            else:

                db.execute("INSERT INTO stocks (user_id, symbol, shares, price, name) VALUES(?, ?, ?, ?, ?)", user_id, symbol, shares, usd(price), name)
                db.execute("UPDATE users SET cash = ? WHERE id = ?", remaining_cash, user_id)
                db.execute("INSERT INTO history (symbol, price, shares, type, user_id, name, total) VALUES(?, ?, ?, ?, ?, ?, ?)", symbol, price, shares, "Buy", user_id, name, total_cost)
                return redirect("/")

    #if get then render the template to buy
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""

    # sql query getting appropriate information to display history from history table
    history = db.execute("SELECT symbol, name, type, shares, time, price, total FROM history WHERE user_id = ?", session["user_id"])

    # if nothin in history dictionary then return apology
    if len(history) == 0:
        return apology("No history", 400)
    else:

        # loop through each row in history
        for transaction in history:

            # isolate price variable
            price = float(transaction["price"])

            # convert price to usd format
            price = usd(price)

            #calculate transaction price
            total = transaction["total"]

            # if there is no total (correcting mistakes from when ther was no total column), calculate total
            if not total:
                total = transaction["price"] * transaction["shares"]

            # convert total to usd format
            total = usd(total)

            # update each row in history to correctly display dollar amounts
            transaction.update({"price": price, "total": total})

        return render_template("history.html", history=history)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    # if form filled out get quote
    if request.method == "POST":
        # ensure form is filled out correctly
        if not request.form.get("symbol"):
            return apology("No Stock Symbol Entered", 400)
        else:
            symbol = request.form.get("symbol").upper()
            quote = lookup(symbol)

            # if quote found provide quote to user
            if quote is not None:
                return render_template("quoted.html", symbol=symbol, name=quote["name"], price=usd(quote["price"]))
            else:
                # if quote does not return a stock symbol return error
                return apology("invalid stock symbol", 400)

    # if get then go to form
    else:
        return render_template("quote.html")

@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""


    # If post register user with provided credentials
    if request.method == "POST":

        # Make sure username was submitted
        if not request.form.get("username"):
            return apology("No username provided", 400)

        # Make sure password was submitted
        elif not request.form.get("password"):
            return apology("No password provided", 400)

        # create variables username, password and confirm_password
        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")

        if len(db.execute("SELECT username FROM users WHERE username = ?", username)) > 0:
            return apology("username already in database", 400)
        # check passwords match
        elif password != confirmation:
            return apology("Password doesn't match", 400)
        # if passwords match hash password and enter username and hash into table

        else:
            hash = generate_password_hash(password)
            db.execute("INSERT INTO users (username, hash) VALUES(?, ?)", username, hash)

            # Query database for username
            rows = db.execute("SELECT * FROM users WHERE username = ?", username)

            # Remember which user has logged in
            session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # If get show register.html
    else:
        return render_template("register.html")

@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    if request.method == "POST":

        # Check if the form was filled out correctly
        if not request.form.get("symbol"):
            return apology("stock symbol needed", 400)
        elif not request.form.get("shares"):
            return apology("number of shares required", 400)

        else:
            symbol = request.form.get("symbol").upper()
            shares = int(request.form.get("shares"))

            # get stock symbol from server
            stock = lookup(symbol)

            # ensure return of propper stock from lookup function
            if not stock:
                return apology("invalid stock symbol", 400)

            name = stock["name"]
            user_id = session["user_id"]
            cash = db.execute("SELECT cash FROM users WHERE id = ?", user_id)[0]["cash"]
            price = stock["price"]

            # sql query to get shares of the requested stock owned by user in database
            owned_stock = db.execute("SELECT symbol, shares FROM stocks WHERE user_id = ? AND symbol = ?", user_id, symbol)

            # check if user owns this stock
            if len(owned_stock) == 0:
                return apology("You do not own this stock.", 400)

            # seperate owned shares out of dictionary
            owned_shares = owned_stock[0]["shares"]

            # ensure user can't sell more shares than they own
            if owned_shares < shares:
                return apology("Insufficient shares", 400)
            else:
                # get total transaction price of all shares being sold
                transaction = price * shares

                # add transaction cost to cash
                cash += transaction

                # update current shares
                total_shares = owned_shares - shares
                db.execute("UPDATE stocks SET shares = ? WHERE symbol = ? AND user_id = ?", total_shares, symbol, user_id)
                db.execute("DELETE FROM stocks WHERE shares = 0")
                db.execute("UPDATE users SET cash = ? where id = ?", cash, user_id)
                db.execute("INSERT INTO history (symbol, name, price, shares, type, user_id, total) VALUES(?, ?, ?, ?, ?, ?, ?)", symbol, name, price, shares, "Sell", user_id, transaction)
                return redirect("/")

    else:
        options = db.execute("SELECT symbol FROM stocks where user_id = ?", session["user_id"])
        return render_template("sell.html", options=options)

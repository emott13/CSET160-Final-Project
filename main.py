from flask import Flask, render_template, request
from sqlalchemy import create_engine, text

app = Flask(__name__)
conn_str = "mysql://root:cset155@localhost/cset160final"
engine = create_engine(conn_str, echo=True)
conn = engine.connect()

@app.route("/")
def home():
    return "home page"

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/login", methods=["POST"])
def loginPost():
    accType = request.form['type'] # can be students or teachers
    # dict makes using it way easier
    accounts = dict( conn.execute(text(f"select email, password from {accType}")).all() )
    email = request.form['email']
    password = request.form['password']

    # checks if an account has that email and then checks if the passwords match
    if email in accounts.keys() and accounts[email] == password:
        return render_template("login.html", success = "Success. You are now logged in")

    return render_template("login.html", error = "Error: Account not found")

@app.route("/signup")
def signup():
    return render_template("signup.html")

@app.route("/signup", methods=["POST"])
def signupPost():
    # Maybe come back to this to add descriptive error messages
    try:
        accType = request.form['type'] # can be students or teachers
        conn.execute(text(f"INSERT INTO {accType} (first_name, last_name, email, password) "
                            "VALUES (:fname, :lname, :email, :password)"), request.form)
        conn.commit()
        return render_template("signup.html")
    except:
        return render_template("signup.html", error = "Error: Invalid input(s)")
        


# temporary


@app.route("/accounts")
@app.route("/accounts.html")
def accounts():
    teacherRows = conn.execute(text('SELECT * FROM teachers;')).all()
    # studentRows = conn.execute(text('SELECT * FROM students;')).all()
    return render_template("accounts.html", teachers = teacherRows)

if __name__ == "__main__":
    app.run(debug=True)
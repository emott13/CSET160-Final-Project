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
    return render_template("login.html", signup = False)

@app.route("/accounts")
@app.route("/accounts.html")
def accounts():
    teacherRows = conn.execute(text('SELECT * FROM teachers;')).all()
    # studentRows = conn.execute(text('SELECT * FROM students;')).all()
    return render_template("accounts.html", teachers = teacherRows)

if __name__ == "__main__":
    app.run(debug=True)
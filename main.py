from flask import Flask, render_template, request
from sqlalchemy import create_engine, text

app = Flask(__name__)
conn_str = "mysql://root:cset155@localhost/boatdb"
engine = create_engine(conn_str, echo=True)
conn = engine.connect()

@app.route("/")
def home():
    return "home page"

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/signup")
def signup():
    return render_template("signup.html")

@app.route("/signup", methods=["POST"])
def signupPost():
    print(request.form)
    for item, item2 in request.form.items():
        print(item, item2)
    return render_template("signup.html")


if __name__ == "__main__":
    app.run(debug=True)
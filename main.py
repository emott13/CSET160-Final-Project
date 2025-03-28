from flask import Flask, render_template, request
from sqlalchemy import create_engine, text, insert, Table, MetaData, desc

app = Flask(__name__)
conn_str = "mysql://root:cset155@localhost/cset160final"
engine = create_engine(conn_str, echo=True)
conn = engine.connect()

metadata = MetaData()
tests = Table('tests', metadata, autoload_with=engine)

@app.route("/", methods = ['POST'])
def home():
    return render_template("home.html")

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/login", methods=["POST"])
def loginPost():
    accType = request.form['type'] # can be students or teachers
    # dict makes using it way easier            # selects either student_id or teacher_id
    accounts = dict( conn.execute(text(f"select email, password from {accType}")).all() )

    email = request.form['email']
    password = request.form['password']

    # checks if an account has that email and then checks if the passwords match
    if email in accounts.keys() and accounts[email] == password:
        logIntoDB(accType, email, password)

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
        logIntoDB(accType, request.form['email'], request.form['password'])
        return render_template("signup.html", success = "Success! You are now signed in")
    except:
        return render_template("signup.html", error = "Error: Invalid input(s)")
        


@app.route("/accounts")
def accounts():
    teacherRows = conn.execute(text('SELECT * FROM teachers;')).all()
    studentRows = conn.execute(text('SELECT * FROM students;')).all()
    return render_template("accounts.html", teachers = teacherRows, students = studentRows)

# @app.route('/create.html', methods = ['GET', 'POST'])
@app.route('/create', methods = ['GET', 'POST'])
def create():
    teacher_id = conn.execute(text('SELECT DISTINCT teacher_id FROM teachers;')).all()
    if request.method == 'POST':
        
        form = request.form.to_dict()
        stmt = insert(tests).values(
            testName=form['testName'], questionNum=form['questionNum'], question_1=form['question_1'],
            question_2=form['question_2'], question_3=form['question_3'], question_4=form['question_4'],
            question_5=form['question_5'], question_6=form['question_6'], question_7=form['question_7'],
            question_8=form['question_8'], question_9=form['question_9'], question_10=form['question_10'],
            question_11=form['question_11'], question_12=form['question_12'], question_13=form['question_13'],
            question_14=form['question_14'], question_15=form['question_15'], teacher_id = form['teacher_id'])
        conn.execute(stmt)
        conn.commit()

    return render_template("create.html", IDs = teacher_id)


@app.route("/test")
def test():
    testRows = conn.execute(text('SELECT * FROM tests;')).all()
    teachers = []
    for teacher_id in testRows:
        teachers.append(conn.execute(text("SELECT CONCAT(first_name, ' ', last_name) FROM teachers "
                                         f"WHERE teacher_id in ({teacher_id[1]})")).all())
    print(testRows)
    print(teachers)
    return render_template("test.html", tests = testRows, teachers = teachers)


# Uses the account type (Either "students" or "teachers") with the email and password to sign the user in the DB
def logIntoDB(accType, email, password):
        # id of the user in the DB
        stored_id = conn.execute(text(f"SELECT {accType[:-1]}_id FROM {accType} "
                                       f"WHERE (email = '{email}') AND (password = '{password}')")).all()[0][0]
        # sets either stored_id or NULL depending on if it's a student or teacher
        stud_id = stored_id if accType == "students" else "NULL"
        teach_id = stored_id if accType == "teachers" else "NULL"

        conn.execute(text("UPDATE loggedin "
                          f"SET student_id = {stud_id}, teacher_id = {teach_id}"))
        conn.commit()


if __name__ == "__main__":
    app.run(debug=True)
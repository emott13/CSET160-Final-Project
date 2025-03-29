from flask import Flask, render_template, request, redirect
from sqlalchemy import create_engine, text, insert, Table, MetaData
from scripts.shhhh_its_a_secret import customHash

app = Flask(__name__)
conn_str = "mysql://root:cset155@localhost/cset160final"
engine = create_engine(conn_str, echo=True)
conn = engine.connect()

metadata = MetaData()
tests = Table('tests', metadata, autoload_with=engine)

@app.route("/", methods = ['POST'])
def home():
    return render_template("home.html")

@app.route("/login", methods=["GET", "POST"])
def loginPost():
    if request.method == "POST":
        accType = request.form['type'] # can be students or teachers
        # dict makes using it way easier            # selects either student_id or teacher_id
        accounts = dict( conn.execute(text(f"select email, password from {accType}")).all() )

        email = request.form['email']
        password = request.form['password']
        checkAgainstHash = customHash(password)

        # checks if an account has that email and then checks if the passwords match
        if email in accounts.keys() and accounts[email] == checkAgainstHash:
            logIntoDB(accType, email, password)

            return render_template("login.html", success = "Success. You are now logged in")

        return render_template("login.html", error = "Error: Account not found")
    
    if request.method == "GET":
        return render_template("login.html")

@app.route("/signup", methods=["GET", "POST"])
def signupPost():
    # Maybe come back to this to add descriptive error messages
    if request.method == "POST":
        try:
            accType = request.form['type'] # can be students or teachers
            password = request.form['password']
            print(password)
            hashedPass = customHash(password)
            print(hashedPass)
            conn.execute(
                text(f"INSERT INTO {accType} (first_name, last_name, email, password) "
                    "VALUES (:fname, :lname, :email, :password)"),
                {"fname": request.form["fname"], 
                "lname": request.form["lname"], 
                "email": request.form["email"], 
                "password": hashedPass}
            )
            conn.commit()
            logIntoDB(accType, request.form['email'], request.form['password'])
            return render_template("signup.html", success = "Success! You are now signed in.")
        except Exception as e:
            print(f"Error: {e}")  # Print actual error
            return render_template("signup.html", error=f"Error: {e}")
    
    if request.method == "GET":
        return render_template("signup.html")
        
@app.route("/accounts.html")
@app.route("/accounts")
def accounts():
    teacherRows = conn.execute(text('SELECT * FROM teachers;')).all()
    studentRows = conn.execute(text('SELECT * FROM students;')).all()
    return render_template("accounts.html", teachers = teacherRows, students = studentRows)

@app.route('/create.html', methods = ['GET', 'POST'])
@app.route('/create', methods = ['GET', 'POST'])
def create():
    teacher_id = conn.execute(text('SELECT DISTINCT teacher_id FROM teachers;')).all()
    teacher_name = conn.execute(text("SELECT CONCAT(first_name, ' ', last_name) FROM teachers;")).all()
    if request.method == 'POST':
        try:
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
            return render_template("create.html", IDs = teacher_id, names = teacher_name)
        except:
            return render_template("create.html", IDs = teacher_id, names = teacher_name, error="Title and number of questions cannot be empty.")
        
    else:
        return render_template("create.html", IDs = teacher_id, names = teacher_name)

@app.route("/test", methods=['GET', 'POST'])
def test(error=""):
    testRows = conn.execute(text('SELECT * FROM tests;')).all()

    if not testRows: # handles if no tests in db
        return render_template("test.html", tests=[], teachers=[], error="No tests available.")

    teachers = []
    for row in testRows:
        teacher_id = row[1]  # teacher_id is the second column
        teacher_name = conn.execute(
            text(f"SELECT CONCAT(first_name, ' ', last_name) FROM teachers WHERE teacher_id = {teacher_id}")).all()
        # teacher_name[0] only gave the first letter of the teacher name, [:] gives full name
        teachers.append(teacher_name[:] if teacher_name else ["Unknown"])

    print(testRows)
    print(teachers)
    return render_template("test.html", tests=testRows, teachers=teachers, error=error)

@app.route("/test/<int:test_id>", methods=["GET", "POST"])
def take_test(test_id):
    # Need to be logged in as a student.
    # This takes you to the login page with an error stating you need to a student
    if loggedIntoType() != "student":
        return render_template("login.html", error = "You must be signed in as a student to take a test")

    stud_id = conn.execute(text("SELECT student_id FROM loggedin")).all()[0][0]
    testData = conn.execute(text("SELECT * FROM tests "
                                f"WHERE test_id = {test_id}")).all()
    # If the test doesn't exist
    if not testData:
        print("This test does not exist")
        return redirect("/test")
    else:
        testData = testData[0] # Makes it easier to use


    if request.method == "GET":
        # Checks if the logged in student has taken the test
        duplicates = conn.execute(text("SELECT * FROM attempts "
                            f"WHERE (test_id = {test_id}) AND (student_id = {stud_id})")).all()
        print(f"duplicates = {duplicates}")
        if duplicates:
            print("ran duplicates")
            return redirect("/test")
            # return test(error="You must be signed in as a student to take a test")

        print(testData)
        questionStartId = 4
        num = testData[3]
        questionEndId = questionStartId + num
        print(questionEndId)

        # Gets all the questions.                                vvv this is how many questions there are 
        questions = [testData[i] for i in range(questionStartId, questionEndId + 1)]
        if testData:
            return render_template("take_test.html", testData = testData, questions = questions)
        else:
            return "This test does not exist"

    
    if request.method == "POST":
        print(f"stud_id: {stud_id}")
        print(testData)
        print(request.form)
        questionsStr = ""
        answersStr = ""

        # for questions and student answers. testData[3] is the question amount
        comma = False
        for i in range(1, testData[3] + 1):
            if comma:
                questionsStr += ', '
                answersStr += ', '
            questionsStr += "answer_" + str(i)
            answersStr += "'" + request.form["question_" + str(i)] + "'"
            comma = True

        conn.execute(text(f"INSERT INTO attempts (test_id, student_id, questionNum, {questionsStr}) "
                                        f"VALUES ({testData[0]}, {stud_id},  {testData[3]}, {answersStr})"))
        conn.commit()

        return redirect("/test")


# Uses the account type (Either "students" or "teachers") with the email and password to sign the user in the DB
def logIntoDB(accType, email, password):
        # id of the user in the DB
        stmt = text(f"SELECT {accType[:-1]}_id FROM {accType} WHERE email = :email")
        result = conn.execute(stmt, {"email": email}).all()
        if not result:
            return  # or handle error gracefully
        stored_id = result[0][0]
        # sets either stored_id or NULL depending on if it's a student or teacher
        stud_id = stored_id if accType == "students" else "NULL"
        teach_id = stored_id if accType == "teachers" else "NULL"

        conn.execute(text("UPDATE loggedin "
                          f"SET student_id = {stud_id}, teacher_id = {teach_id}"))
        conn.commit()

def loggedIntoType():
    value = conn.execute(text("SELECT * FROM loggedin")).all()
    print(value)
    # If student_id place has something in it
    if value[0][0]:
        return "student"
    # If teacher_id place has something in it
    elif value[0][1]:
        return "teacher"
    else: # must not be signed in
        return ""

if __name__ == "__main__":
    app.run(debug=True)
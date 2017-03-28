from oct2py import octave
from flask import Flask, render_template, request
import numpy
app = Flask(__name__)

@app.route('/')
def homepage():
    return render_template("index.html")

@app.route('/result',methods =['POST', 'GET'])
def result():
    if request.method == 'POST':
        mail_eg = str(request.form['mail_eg'])
        if len(mail_eg) < 10:
            return render_template("index.html",context="Invalid length")
        else:
            text_file = open("output.txt","w")
            text_file.write(str(mail_eg))
            text_file.close()
            p = octave.predictor("output.txt")
            open("output.txt",'w').close()
            if p >=0:
                output= "spam"
            else:
                output= "not a spam"
            if p > 1:
                p = (p/2)*100
            elif p<0.5 and output=="spam":
                p = (p*2)*100
            else:
                p = p*100
            return render_template("results.html",content=mail_eg,probability=p,output=output)
        return str(len(mail_eg))
    else:
        return request.args.get('mail_eg')

if __name__ == "__main__":
    app.run()
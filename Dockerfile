FROM python:3.8

COPY . .
ENV FLASK_APP=app/app.py
RUN pip install -r requirements.txt

EXPOSE 5000

CMD python -m flask run --host 0.0.0.0

FROM python

WORKDIR /app

ADD . /app

RUN pip install flask

EXPOSE 80

CMD [ "python", "webapp.py" ]
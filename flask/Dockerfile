FROM python:3.6.2-slim AS base

ADD ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ADD ./app /app
WORKDIR /app

ENTRYPOINT ["python"]
CMD ["app.py"]

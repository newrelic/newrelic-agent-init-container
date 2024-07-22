ARG RUNTIME_VERSION=3.7
FROM python:$RUNTIME_VERSION

RUN pip install flask gunicorn

COPY main.py .

CMD ["gunicorn", "main:app", "-b", "0.0.0.0:8000", "--workers=1"]

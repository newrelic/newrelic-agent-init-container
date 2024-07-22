ARG ${RUNTIME_VERSION}=3.12
FROM python:${RUNTIME_VERSION}

RUN pip install flask==3.0.3 gunicorn==22.0.0

COPY main.py .

CMD ["gunicorn", "main:app", "-b", "0.0.0.0:8000", "--workers=1"]

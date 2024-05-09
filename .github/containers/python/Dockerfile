FROM python:3.12.3-bullseye

RUN pip install flask==3.0.3 gunicorn==22.0.0

COPY main.py .

CMD ["gunicorn", "main:app", "-b", "0.0.0.0:8000"]
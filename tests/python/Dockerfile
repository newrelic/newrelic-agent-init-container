ARG RUNTIME_VERSION=3.11
FROM python:$RUNTIME_VERSION

# Install dependencies
RUN pip install flask gunicorn

# Remove pip to ensure our vendored version is working
RUN rm -rf /usr/local/lib/**/site-packages/pip

# Add test app
COPY main.py .
CMD ["gunicorn", "main:app", "-b", "0.0.0.0:8000", "--workers=1"]

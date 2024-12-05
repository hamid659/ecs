FROM python:3.9-slim

WORKDIR /app

COPY app.py .

RUN pip install flask gunicorn  # Install Gunicorn along with Flask

CMD ["gunicorn", "-b", "0.0.0.0:80", "app:app"]  # Run Flask using Gunicorn

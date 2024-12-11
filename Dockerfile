FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install spacy model
RUN python -m spacy download en_core_web_sm

# Copy the entire application
COPY . .

# Ensure static files are accessible
RUN chmod -R 755 /app/static

CMD ["gunicorn", "--bind=0.0.0.0:8000", "--timeout=600", "main:app"]
# ---------- Stage 1: Builder ----------
FROM python:3.10-slim AS builder

WORKDIR /app

# Install build deps
RUN apt-get update && apt-get install -y gcc build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY . .

# ---------- Stage 2: Runtime ----------
FROM python:3.10-slim

WORKDIR /app

# Copy libraries from builder stage
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app /app

ENV PATH=/root/.local/bin:$PATH

CMD ["python", "main.py"]


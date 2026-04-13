FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

COPY . .

# COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# COPY src/ . 

#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "main:app"]

# De app (a instância Flask pura) para application (a instância do Flask encapsulada pelo middleware do Prometheus).

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "main:application"]
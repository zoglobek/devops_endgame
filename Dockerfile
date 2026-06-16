FROM python:3.9-slim
WORKDIR /app
RUN pip install --upgrade pip
COPY app/. /app
RUN ls
RUN pip install -r /app/requirements.txt
CMD ["python", "/app/main.py"]
EXPOSE  5000

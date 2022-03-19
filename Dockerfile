FROM python:3.7-alpine
#ADD . /files
WORKDIR /files
RUN pip install uploadserver
CMD ["python", "-m", "uploadserver", "8181"]

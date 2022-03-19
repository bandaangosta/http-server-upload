## Usage

http://IP:8181   
http://IP:8181/upload   
or  
http://IP/upload
http://IP/upload/upload

## Dockerfile (place in /home/jortiz/http-server-upload/)

    FROM python:3.7-alpine
    WORKDIR /files
    RUN pip install uploadserver
    CMD ["python", "-m", "uploadserver", "8181"]


## docker-compose.yml
    
    version: '3'
    
    services:
      # The reverse proxy service (Træfik)
      reverse-proxy:
        image: traefik  # The official Traefik docker image
        command: --api --docker --accesslog  # Enables the web UI and tells Træfik to listen to docker
        restart: always
        ports:
          - "80:80"      # The HTTP port
          - "8080:8080"  # The Web UI (enabled by --api)
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock  # So that Traefik can listen to the Docker events
    
      # HTTP upload server
      upload-server:
        build:
          context: ./http-server-upload/
          dockerfile: Dockerfile
        restart: always
        volumes:
          - /home/jortiz/http-server-upload/files:/files
        labels:
          - "traefik.frontend.rule=PathPrefixStrip:/upload"
          - "traefik.frontend.priority=10"
        depends_on:
          - reverse-proxy
        ports:
          - "8181:8181"
    
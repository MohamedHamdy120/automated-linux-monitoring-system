FROM ubuntu:latest
COPY monitor.sh /monitor.sh
RUN apt-get update && apt-get install -y curl
RUN chmod u+x /monitor.sh
CMD ["./monitor.sh"]

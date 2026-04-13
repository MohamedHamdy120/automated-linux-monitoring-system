FROM ubuntu:latest
COPY monitor.sh /monitor.sh
RUN chmod u+x /monitor.sh
CMD ["./monitor.sh"]

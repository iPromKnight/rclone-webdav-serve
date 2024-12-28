FROM rclone/rclone:latest

RUN mkdir -p /{cache,data}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080 5572

ENTRYPOINT ["/entrypoint.sh"]

FROM icloudpd/icloudpd:1.26.1

COPY init.sh /init.sh
RUN chmod +x /init.sh
RUN apk add jq
ENTRYPOINT ["sh", "-c", "while true; do sleep 1000; done;"]
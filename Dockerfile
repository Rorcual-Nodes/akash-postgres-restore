FROM postgres:alpine3.18

RUN apk update && apk add curl zip netcat-openbsd apk-cron

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install --bin-dir /usr/bin

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

ENV POSTGRES_HOST=postgres
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres

ENV BACKUP_HOST="https://s3.filebase.com"
ENV BACKUP_SCHEDULE="*/15 * * * *"
ENV BACKUP_RETAIN="7 days"

COPY ./crontab /crontab

CMD /scripts/run.sh

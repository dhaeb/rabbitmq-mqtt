#
# MQTT/RabbitMQ
#
# based on:
# RabbitMQ Dockerfile
#
# https://github.com/dockerfile/rabbitmq
#

# Pull base image.
FROM dockerfile/ubuntu

# Add files.
ADD bin/rabbitmq-start /usr/local/bin/
ADD etc/rabbitmq/rabbitmq.config /etc/rabbitmq/
ADD etc/rabbitmq/rabbitmq-env.conf /etc/rabbitmq/



# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
#VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

# Install RabbitMQ.
RUN wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list 

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server apg
RUN rm -rf /var/lib/apt/lists/*

RUN rabbitmq-plugins enable rabbitmq_management
RUN rabbitmq-plugins enable rabbitmq_mqtt 

RUN chmod +x /usr/local/bin/rabbitmq-start

RUN /usr/local/bin/rabbitmq-start & sleep 10 && rabbitmqctl add_user admin admin && rabbitmqctl set_user_tags admin administrator && sleep 3 && rabbitmqctl stop

# Define default command.
CMD ["rabbitmq-start"]

# Expose ports.
EXPOSE 5672
EXPOSE 15672
EXPOSE 1883


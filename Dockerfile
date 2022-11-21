FROM cyberbotics/webots.cloud:R2022b

# Environment variables needed for Webots
# https://cyberbotics.com/doc/guide/running-extern-robot-controllers#remote-extern-controllers
ENV PYTHONPATH=${WEBOTS_HOME}/lib/controller/python38
ENV PYTHONIOENCODING=UTF-8
ENV LD_LIBRARY_PATH=${WEBOTS_HOME}/lib/controller:${LD_LIBRARY_PATH}

# Default internal docker ip, used to connect controller to Webots
ENV WEBOTS_CONTROLLER_URL=tcp://172.17.0.1:3005

# Copies all the file of the current folder into the docker container
COPY . .

# The default controller name is extracted from webots.yml and is given by the build-arg:
ARG DEFAULT_CONTROLLER
ENV DEFAULT_CONTROLLER=${DEFAULT_CONTROLLER}

RUN apt-get update
RUN apt-get install -y python3-pip
RUN pip3 install numpy opencv-python

# Entrypoint command to launch default Python controller script
# (In shell form to allow variable expansion)
ENTRYPOINT cd controllers/$DEFAULT_CONTROLLER && python3 $DEFAULT_CONTROLLER.py

# Pull your base docker image
# Using rocker for R but could use python:3.8-slim or similar
FROM rocker/r-ver:4.0.0-ubuntu18.04

# install necessary packages for connecting from R to SQL databases
RUN apt-get update -y && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    tdsodbc \
    odbc-postgresql \
    tzdata

COPY odbc.ini /etc/odbc.ini
COPY odbcinst.ini /etc/odbcinst.ini

RUN R -e "install.packages(c('odbc', 'readr'))"
RUN install2.r odbc renv

# Remove root privileges from the container process and run as 'cronbot'
RUN groupadd --gid 1000 cronbot && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash cronbot


# Create a directory called 'app' to hold your code
RUN mkdir /home/cronbot/app
# Add your local directory (also called 'app') into 'app'
ADD app /home/cronbot/app/app

# Ensure all files are owned by the user cronbot
RUN chown -R "1000:1000" /home/cronbot
USER cronbot
WORKDIR /home/cronbot/app

# Start the container with a 'dummy' process that prevents the container
# immediately stopping
CMD tail -f /dev/null






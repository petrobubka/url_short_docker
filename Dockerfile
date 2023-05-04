FROM ubuntu:latest

# Install JDK 16, PostgreSQL, and other dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y wget postgresql git && \
    rm -rf /var/lib/apt/lists/*

# Download and install OpenJDK 16
RUN wget https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_linux-x64_bin.tar.gz && \
    tar xfvz openjdk-16.0.1_linux-x64_bin.tar.gz && \
    mv jdk-16.0.1 /usr/local && \
    rm openjdk-16.0.1_linux-x64_bin.tar.gz

# Set up database
USER postgres
USER root

# Clone the repository
RUN git clone https://github.com/petrobubka/url-shortener.git
WORKDIR url-shortener


# Set up the application
ENV JAVA_HOME=/usr/local/jdk-16.0.1
ENV PATH=$JAVA_HOME/bin:$PATH
RUN chmod +x mvnw && ./mvnw package -DskipTests

EXPOSE 8080

CMD service postgresql start && java -jar ./target/url-shortener-0.0.1-SNAPSHOT.jar

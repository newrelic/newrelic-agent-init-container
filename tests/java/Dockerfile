# BUILD STAGE
FROM eclipse-temurin:17-jdk-jammy as build

# Install git
RUN apt update
RUN apt install -y git

# Clone and build SpringBoot PetClinic Java service
RUN git clone https://github.com/spring-projects/spring-petclinic
# Checkout a specific commit to pin the PetClinic service to a known working version. Comment this out to get latest version.
RUN cd ./spring-petclinic && git checkout 923e2b7aa331b8194a6579da99fb6388f15d7f3e
# Build SpringBoot PetClinic Java service
RUN cd ./spring-petclinic && ./mvnw -Dmaven.test.skip=true clean package

# PRODUCTION STAGE
FROM eclipse-temurin:17-jre-jammy as production

# Create work directory
WORKDIR /petclinic-app

# Copy PetClinic jar from build stage to work directory
COPY --from=build /spring-petclinic/target/spring-petclinic*.jar .

# SpringBoot listens on port 8080 by default
# To change it set the -Dserver.port=8083 system propery in the following CMD step
# Alternatively, change the SERVER_PORT and port mapping in docker-compose.yml
EXPOSE 8080

CMD java -jar spring-petclinic*.jar

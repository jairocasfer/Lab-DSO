FROM docker.io/eclipse-temurin:17.0.3_7-jre-focal
LABEL NAME = "WebGoat: Application for examples CI/CD"

RUN mkdir /home/webgoat

COPY target/webgoat-2023.5-SNAPSHOT.jar /home/webgoat/

EXPOSE 8080
EXPOSE 9090

WORKDIR /home/webgoat
ENTRYPOINT [ "java", \
   "-Duser.home=/home/webgoat", \
   "-Dfile.encoding=UTF-8", \
   "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
   "--add-opens", "java.base/java.util=ALL-UNNAMED", \
   "--add-opens", "java.base/java.lang.reflect=ALL-UNNAMED", \
   "--add-opens", "java.base/java.text=ALL-UNNAMED", \
   "--add-opens", "java.desktop/java.beans=ALL-UNNAMED", \
   "--add-opens", "java.desktop/java.awt.font=ALL-UNNAMED", \
   "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
   "--add-opens", "java.base/java.io=ALL-UNNAMED", \
   "--add-opens", "java.base/java.util=ALL-UNNAMED", \
   "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
   "--add-opens", "java.base/java.io=ALL-UNNAMED", \
   "-Drunning.in.docker=true", \
   "-Dwebgoat.host=0.0.0.0", \
   "-Dwebwolf.host=0.0.0.0", \
   "-Dwebgoat.port=8080", \
   "-Dwebwolf.port=9090", \
   "-jar", "webgoat-2023.5-SNAPSHOT.jar" ]

   CMD [ "sh", "-c" ]


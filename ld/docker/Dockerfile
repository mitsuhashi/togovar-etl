 # Dockerfile
FROM eclipse-temurin:17-jdk
WORKDIR /juicer
# Juicer Toolsのjarファイルをダウンロード
# curl をインストール
#RUN apt-get update && apt-get install -y curl
# Juicer Tools の Jar ファイルをダウンロード
#RUN curl -L -o /juicer/JuicerTools.jar http://hicfiles.tc4ga.com.s3.amazonaws.com/public/Juicebox/Juicebox_1.9.8.jar
ADD http://hicfiles.tc4ga.com.s3.amazonaws.com/public/Juicebox/Juicebox_1.9.8.jar  /juicer/Juicerbox.jar
#ENV JUICER_TOOLS /juicer/JuicerTools.jar
# Java のバージョンとパスを確認
RUN java -version
RUN echo $PATH
RUN which java || true
RUN ls -l /usr/bin/java || true
RUN ls -l /usr/local/bin/java || true
#CMD ["java", "-jar", "/juicer/JuicerTools.jar"]
CMD ["bash"]
USER root

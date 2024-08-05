FROM openjdk:8
ADD jarstaging/com/helios/helios-demo-workshop/2.1.2/helios-demo-workshop-2.1.2.jar b80.jar 
ENTRYPOINT [ "java", "-jar", "b80.jar" ]
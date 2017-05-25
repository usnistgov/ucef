# Exclude Log4j from Portico

**Disclaimer**: To read this markdown file, use Github flavor (e.g. open it in MacDown) otherwise you may not see the content properly.

-

When using `portico` in our maven project, there may some problems arise regarding to conflicting `log4j` versions in the classpath.
As `portico` uses `onejar`, its `.jar` includes all the dependencies they're using.

**TASK**: Make `portico.jar` such that it doesn't include `log4j` classes

## Steps to reproduce


1. Clone the `portico` project from github:

    ```
    git clone https://github.com/openlvc/portico.git
    cd portico/
    ```

2. Edit the `java.xml` ant build script:

	Replace

	```
    87    <path id="lib.log4j.classpath">
    88        <fileset dir="${log4j.dir}" includes="**/*"/>
    89    </path>
	```

	with

	```
	87    <path id="lib.log4j.classpath">
	88        <fileset dir="${log4j.dir}" includes="**/*.jar"/>
	89    </path>
	```

	and replace

	```
	330    <unjar dest="${onejar.dir}">
	331        <fileset dir="${lib.dir}" includes="**/*.jar" excludes="testng/**/*"/>
	332    </unjar>
	```

	with

	```
	330    <unjar dest="${onejar.dir}">
	331        <fileset dir="${lib.dir}" includes="**/*.jar" excludes="testng/**/*,log4j/**/*"/>
	332    </unjar>
	```

3. Delete the content of

	```
	portico/codebase/lib/log4j/
	```
	
	and copy `log4j.jar`'s version `1.2.17`

4. Build the project:

	```
	cd codebase/
	./ant release.thin
	```

5. Create a `pom.xml` file for current build:

	```
	<?xml version="1.0" encoding="UTF-8"?>
	<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
	         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	    <modelVersion>4.0.0</modelVersion>
	    <groupId>org.porticoproject</groupId>
	    <artifactId>portico</artifactId>
	    <version>2.1.0</version>
	
	    <dependencies>
	        <dependency>
	            <groupId>log4j</groupId>
	            <artifactId>log4j</artifactId>
	            <version>1.2.17</version>
	        </dependency>
	    </dependencies>
	</project>
	```

6. Upload to `Apache Archiva` or your choice of maven repository

	![Upload Portico to Archiva](image/upload_archiva_portico.png)

7. Use it as a dependency in a `pom.xml`

	```
	<properties>
        <portico.version>2.1.0-LOG4J</portico.version>
    </properties>
	```

	```
	<dependency>
	    <groupId>org.porticoproject</groupId>
	    <artifactId>portico</artifactId>
	    <version>${portico.version}</version>
	</dependency>
	```
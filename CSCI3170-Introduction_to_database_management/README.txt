Group 5

Group Member:
	Zhou Conghui 			1155014404 
	Chow Yui Ching Eugene   	1155009126
	Zhou Zhihao 			1155014412 

Files:

	User Manual.pdf        

	java/data/				Directory used to store the dataset files: categoty.txt, manufacturer.txt, part.txt, salesperson.txt, transaction.txt

	java/proj$Query.class	Compiled Java class to store all sql queries used in java application
	java/proj.class			Compiled Java class
	java/proj.java			Java application source code
	java/ojdbc6.jar			JDBC Oracle database driver 

	web/					Web interface root directory
	index.php				source code for web interface


Compilation:
	cd to java/

	$ set path=($path/usr/local/java2/jdk1.6.0_11/bin)
	$ javac proj.java

Execution:
	cd to java/

	$ java -classpath ojdbc6.jar:. proj

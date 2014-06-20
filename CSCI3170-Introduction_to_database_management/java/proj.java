import java.sql.*;
import java.io.File;
import java.util.*;
import java.io.FileNotFoundException;
import java.util.Calendar;
import java.text.SimpleDateFormat;

//java -classpath ojdbc6.jar:. proj

public class proj {

    static Connection conn = null;

    private final static String DB_Url = "jdbc:oracle:thin:@db12.cse.cuhk.edu.hk:1521:db12";
    private final static String DB_User = "username";
    private final static String DB_Password = "password";

    private final static SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

    static boolean is_table_created = false;

	public static void main(String[] args) throws SQLException, FileNotFoundException{

		//Load JDBC Driver
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			System.err.println("Unable to load the driver class.");
			return;
		}

        Connection conn = null;
        String tableName = "part";
        String query = "select count(*) from  " + tableName;
        Statement stmt = null;
        ResultSet rs = null;

        try {
          conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
          stmt = conn.createStatement();
          rs = stmt.executeQuery(query);
          System.out.println("\n********Tables Already Exist in Database!********\n");;
          is_table_created = true;
            }
        catch (Exception e ) {
          // table does not exist or some other problem
          //e.printStackTrace();
          System.out.println("\n*********Tables Currently Not Exist in Database!************\n");
          is_table_created = false;
        }

        stmt.close();
        conn.close();


		System.out.println("Welcome to Sales System!");

        main_menu();

    }// end main function

    private static void main_menu()throws SQLException, FileNotFoundException{

        Scanner input = new Scanner(System.in);

        while (true) {
            System.out.println("\n--------------- Main Menu -------------------");
            System.out.println("What operation would you like to perform?\n");
            System.out.println("1. Data Manipulation");
            System.out.println("2. General Data Operations");
            System.out.println("3. Exit (you may drop table before exit if needed)");
            System.out.print("Enter your Choice: ");
           
            if (input.hasNextInt()) {
                    switch (input.nextInt()) {
                        case 1:
                            dataManipulation();
                            break;
                        case 2:
                            if (is_table_created)
                            dataOperation();
                            else {
                                System.out.println("\nNo table exists now! Please create table first.");
                                System.out.println("Return to the main menu");
                                main_menu();
                            }
                            break;
                        case 3: 
                            System.out.println("\nExit Program, Bye!");
                            System.exit(0);

                        default:
                            System.out.println("\nUnknown action! Please select again.");
                    }
                } else {

                    System.out.println("\nUnknown action! Please select again.");
                    input.next();

                }//end of if else
        }//end while
    
    }// end of main menu

    private static void dataManipulation() throws SQLException, FileNotFoundException{
        
        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.println("\nWhat operation would you like to perform?");
            System.out.println("1. Create All Tables");
            System.out.println("2. Delete All Tables");
            System.out.println("3. Load Data into Tables");
            System.out.println("4. Show Information in Tables");
            System.out.println("5. Return to upper menu");
            System.out.print("Enter your choice ");

            if (sc.hasNextInt()) {
                switch (sc.nextInt()) {
                case 1:
                    createTables();
                    break;
                case 2:
                    dropTables();
                    break;
                case 3:
                    loadData();
                    break;
                case 4:
                    showInformation();
                    break;
                case 5:
                    return;
                default:
                    System.out.println("\nUnknown action! Please select again.");
                }//end switch
            } else {
                System.out.println("\nUnknown action! Please select again.");
                sc.next();
            }
        }//end while
    
    }// edn of data manupulation

    private static void dataOperation() throws SQLException,FileNotFoundException{

        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.println("\nWhat operation would you like to perform?");
            System.out.println("1. Search and List Parts");
            System.out.println("2. Commit a new transaction");
            System.out.println("3. Show the Transaction History");
            System.out.println("4. Rank category sales in ascending order");
            System.out.println("5. Rank salespersons sales in ascending order");
            System.out.println("6. Return to upper menu");
            System.out.print("Enter your choice ");

            if (sc.hasNextInt()) {
                switch (sc.nextInt()) {
                case 1:
                    search_list_part();
                    break;
                case 2:
                    add_new_transaction();
                    break;
                case 3:
                    show_transaction_history();
                    break;
                case 4:
                    rank_sales_category();
                    break;
                case 5:
                    rank_sales_salesperson();
                    break;
                case 6:
                    return;
                default:
                    System.out.println("\nUnknown action! Please select again.");
                }//end switch
            } else {
                System.out.println("\nUnknown action! Please select again.");
                sc.next();
            }
        }//end while

    }// end of data operation

    private static void createTables()  throws SQLException {// ok
        
        if ( is_table_created)  
            System.out.println("\nTables already exists. Try dropping tables first");

        else{
            try{

                execStatements(proj.Query.CREATETABLE);
                System.out.println("\nProcessing.....Done");
                is_table_created = true;

                } catch (SQLSyntaxErrorException e) {
                 System.out.println("\nTables already exists. Try dropping tables first");            
                }
            }   

    }// end of createTable function

    private static void dropTables() throws SQLException {// ok

        if ( !is_table_created)
            System.out.println("\nNo Tables exists. Try creating tables first");

        else{

            try{

                execStatements(proj.Query.DROPTABLE);
                System.out.println("\nProcessing.....Done");
                is_table_created = false;

                }catch (SQLSyntaxErrorException e) {
                    e.printStackTrace();
                 }     
            }       

    }// end of dropTable function

    private static void execStatements(String[] sql) throws SQLException {
        
        Connection conn = null;
        Statement stmt=null;

        try {
            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
            stmt = conn.createStatement();
            
            for (String query : sql) {
                stmt.executeUpdate(query);
            }   
        } catch (SQLException e) {
            e.printStackTrace();
        }finally{

                stmt.close();
                conn.close();

                }

        
    }// end of exec function

    private static void showInformation () throws SQLException,FileNotFoundException{

        Scanner input = new Scanner(System.in);

        while (true){// is this loop right?

            System.out.println("\nWhich table do you want to show?");
            System.out.println("1. Category");
            System.out.println("2. Manufacturer ");
            System.out.println("3. Part ");
            System.out.println("4. Salesperson ");
            System.out.println("5. Transaction Record ");
            System.out.println("6. Return to upper menu");
            System.out.print("Type in the Target Table: ");

            if (input.hasNextInt()) { // heed to handle wrong input
                    switch (input.nextInt()) {
                        case 1:
                            showTable("category");
                            showTable_detail(1);
                            break;
                        case 2:
                            showTable("manufacturer");
                            showTable_detail(2);
                            break;
                        case 3:
                            showTable("part");
                            showTable_detail(3);
                            break;
                        case 4:
                            showTable("salesperson");
                            showTable_detail(4);
                            break;
                        case 5:
                            showTable("transactions"); 
                            showTable_detail(5);
                            break;
                        case 6:
                            return;
                        default:
                            System.out.println("\nUnknown action! Please select again.");
                    }// end switch
                } else {
                    System.out.println("\nUnknown action! Please select again.");
                    input.next();
                }// end else if 
        }//end while
    
    }// end function show information

    //how about there is no table now?
    private static void showTable(String table_name) throws SQLException, FileNotFoundException{

        Connection conn = null;
        Statement stmt=null;
        ResultSet rs =null;

        try {
            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);

            System.out.println("\nGeneral Table Information:");
            System.out.println("+------------------------------------------------+");
            System.out.printf("|%20s|%20s|\n","Table Name","Number of Records");
            System.out.println("+------------------------------------------------+");

        
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT count(*) AS COUNT FROM " + table_name);
            while (rs.next()) {
            System.out.printf("|%20s|%20d|\n", table_name, rs.getInt("COUNT"));
            }
            
            System.out.println("+------------------------------------------------+");
            System.out.println("End of General Table Information");

        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("\nNo table now! Please create table first!");
            System.out.println("Return to Main Menu");
            main_menu();
        } finally{ // ## follow this style!

                rs.close();// ## what happens?
                stmt.close();
                conn.close();

                }

    }// end of showTable

    private static void showTable_detail(int table_choice) throws SQLException, FileNotFoundException{

        Connection conn = null;
        Statement stmt=null;
        ResultSet rs =null;

        try {

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);

            System.out.println("\nDetailed Table Information:");

            if(table_choice ==1){//show category
            stmt = conn.createStatement();
            rs = stmt.executeQuery(proj.Query.SHOWTABLE[0]);
            
            System.out.printf("\n|%20s|%20s|\n", "Category ID", "Category Name");

                while (rs.next()) {
                    System.out.printf("|%20d|%20s|\n" ,rs.getInt(1), rs.getString(2));
                }
            }

            if(table_choice ==2){//show manufacturer
            stmt = conn.createStatement();
            rs = stmt.executeQuery(proj.Query.SHOWTABLE[1]);
            
            System.out.printf("\n|%20s|%20s|%60s|%20s|\n", "Manufacturer ID", "Manufacturer Name","Manufacturer Address","Manufacturer Phone");

                while (rs.next()) {
                    System.out.printf("|%20d|%20s|%60s|%20d|\n" ,rs.getInt(1), rs.getString(2),rs.getString(3),rs.getInt(4));
                }
            }

            if(table_choice ==3){//show part
            stmt = conn.createStatement();
            rs = stmt.executeQuery(proj.Query.SHOWTABLE[2]);
            
            System.out.printf("\n|%20s|%20s|%20s|%20s|%20s|%20s\n", "Part ID", "Part Name","Part Price","Manufacturer ID","Category ID","Quantity");

                while (rs.next()) {
                    System.out.printf("|%20d|%20s|%20d|%20d|%20d|%20d\n" ,rs.getInt(1), rs.getString(2),rs.getInt(3),rs.getInt(4),rs.getInt(5),rs.getInt(6));
                }
            }
        
            if(table_choice ==4){//show salesperson
            stmt = conn.createStatement();
            rs = stmt.executeQuery(proj.Query.SHOWTABLE[3]);
            
            System.out.printf("\n|%20s|%20s|%45s|%20s|\n", "Salesperson ID", "Salesperson Name","Salesperson Address","Salesperson Phone");

                while (rs.next()) {
                    System.out.printf("|%20d|%20s|%45s|%20d|\n" ,rs.getInt(1), rs.getString(2),rs.getString(3),rs.getInt(4));
                }
            }

            if(table_choice ==5){//show transaction
            stmt = conn.createStatement();
            rs = stmt.executeQuery(proj.Query.SHOWTABLE[4]);
            
            System.out.printf("\n|%20s|%20s|%20s|%20s|\n", "Transaction ID", "Part ID","Salesperson ID","Date");

                while (rs.next()) {
                    System.out.printf("|%20d|%20d|%20d|%20s|\n" ,rs.getInt(1), rs.getInt(2),rs.getInt(3),df.format(rs.getDate(4)));
                }
            }


            System.out.println("End of detailed Table Information\n");

        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("\nNo table now! Please create table first!");
            System.out.println("Return to Main Menu");
            main_menu();
        } finally{ // ## follow this style!

                rs.close();// ## what happens?
                stmt.close();
                conn.close();

                }
    }// end of show detail table

    private static void loadData()throws SQLException, FileNotFoundException,InputMismatchException{

        System.out.println("\n---------------------- Please noted -----------------------\n");
        System.out.println("Make Sure Load Data in Right Order!");
        System.out.println("Recommend Procedure:");
        System.out.println("categoty -> manufacturer -> salesperson -> part -> transaction");
        System.out.println("\n---------------------- Please noted -----------------------");

        System.out.println("\nType in the Source Data File Path: ");
        Scanner scan = new Scanner(System.in);
        Scanner choose = new Scanner(System.in);
        Scanner sc = null;
        String filenname;
        
        filenname = scan.nextLine();//read file path from user

        try{ // try to load file
            File fl = new File(filenname);
            sc = new Scanner(fl).useDelimiter("\t|\n");

        } catch (FileNotFoundException e) {
            System.err.println(filenname + " not found.");
            System.out.println("Back to Main Menu!");
            main_menu();
        }

        int number =6;//get user's choice of table to insert

        System.out.println("\nWhat is the target table?");
        System.out.println("1. Category");
        System.out.println("2. Manufacturer ");
        System.out.println("3. Part ");
        System.out.println("4. Salesperson ");
        System.out.println("5. Transaction Record ");
        System.out.println("6. Return to upper menu");
        System.out.print("Type in the Target Table: ");

        do {// ensure the number from 1 to 6

            if (number <= 0 || number > 6)
                System.out.println("\nUnknown action! Please select again.");

            while (!choose.hasNextInt()) {
                System.out.println("\nUnknown action! Please select again.");
                choose.next(); 
            }
            number = choose.nextInt();
        } while (number <= 0 || number > 6);

        Connection conn = null;
        PreparedStatement pstmt=null;

        try {
        conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
        
        try{
        if(number ==1){//insert into category
            pstmt = conn.prepareStatement(proj.Query.INSERTCATEGORY);
            while (sc.hasNext() == true) {
                pstmt.setInt(1, sc.nextInt());//c_id
                pstmt.setString(2, sc.next());//c_name
                pstmt.executeUpdate();
            }
            System.out.println("\nProcessing.....Done");

        }

         else if(number ==2){//insert into manufacturer
            pstmt = conn.prepareStatement(proj.Query.INSERTMANUACTURER);
            while (sc.hasNext() == true) {
                pstmt.setInt(1, sc.nextInt());//m_id
                pstmt.setString(2, sc.next());//m_name
                pstmt.setString(3, sc.next());//m_address
                pstmt.setInt(4, sc.nextInt());//m_phone number
                pstmt.executeUpdate();
            }
            System.out.println("\nProcessing.....Done");
        }

        else if(number ==3){//insert into part
            pstmt = conn.prepareStatement(proj.Query.INSERTPART);
            while (sc.hasNext() == true) {
                pstmt.setInt(1, sc.nextInt());//p_id
                pstmt.setString(2, sc.next());//p_name
                pstmt.setInt(3, sc.nextInt());//p_price
                pstmt.setInt(4, sc.nextInt());//m_id
                pstmt.setInt(5, sc.nextInt());//c_id
                pstmt.setInt(6, sc.nextInt());//p_quality
                pstmt.executeUpdate();
            }
            System.out.println("\nProcessing.....Done");
        }

        else if(number ==4){//insert into salesperson
            pstmt = conn.prepareStatement(proj.Query.INSERTSALESPERSONS);
            while (sc.hasNext() == true) {
                pstmt.setInt(1, sc.nextInt());//s_id
                pstmt.setString(2, sc.next());//s_name
                pstmt.setString(3, sc.next());//s_address
                pstmt.setInt(4, sc.nextInt());//s_phone
                pstmt.executeUpdate();
            }
            System.out.println("\nProcessing.....Done");
        }

        else if(number ==5){//insert into transactions
            pstmt = conn.prepareStatement(proj.Query.INSERTTRANSACTIONS);
            while (sc.hasNext() == true) {
                pstmt.setInt(1, sc.nextInt());//t_id
                pstmt.setInt(2, sc.nextInt());//p_id
                pstmt.setInt(3, sc.nextInt());//s_id
                pstmt.setString(4, sc.next());//t_date
                pstmt.executeUpdate();
            }
            System.out.println("\nProcessing.....Done");
        }
        
        else return;
    } catch(InputMismatchException e) {
            System.out.println("\nFail to load data");
            System.out.println("Choose the wrong table!");
    }

        
        }catch (SQLException e) {
            System.out.println("\nFail to load data");
            System.out.println("Data has already been load!");
        }finally{ // close conn etc

                pstmt.close();
                conn.close();

                }
    }// end of load data

    private static void search_list_part()throws SQLException{// seems ok now

        int number =1;//get user's choice of search criterion

        System.out.println("\nChoose the Search Criterion ");
        System.out.println("1. Category Name");
        System.out.println("2. Manufacturer Name");
        System.out.println("3. Part Name");
        System.out.print("\nType in the Search Criterion: ");

        Scanner choose = new Scanner(System.in);

        do {// ensure the number from 1 to 3

            if (number <= 0 || number > 3)
                System.out.print("\nUnknown action! Please select again:");

            while (!choose.hasNextInt()) {
                System.out.print("\nUnknown action! Please select again:");
                choose.next(); 
            }
            number = choose.nextInt();
        } while (number <= 0 || number > 3);

        String search;
        Scanner scan = new Scanner(System.in);
        System.out.print("\nType in the Search Keyword: ");
        search = scan.nextLine(); //get search keyword

        Connection conn = null;
        PreparedStatement pstmt=null;
        ResultSet rs =null;

        try {// execute query to search

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
    
            switch(number){
                case 1:
                    pstmt = conn.prepareStatement(proj.Query.SEARCHPARTS[0]);
                    break;
                case 2:
                    pstmt = conn.prepareStatement(proj.Query.SEARCHPARTS[1]);
                    break;
                case 3:
                    pstmt = conn.prepareStatement(proj.Query.SEARCHPARTS[2]);

            }// end of prepare sql statement

            pstmt.setString(1, "%"+search+"%");
            rs = pstmt.executeQuery();//get query result

            System.out.printf("\n|%10s|%20s|%20s|%20s|%20s|\n", "Part ID", "Part Name", "Category", "Manufacturer","Available Quantity");
            while (rs.next()) {
                if(rs.getInt(5) != 0){
                    System.out.printf("|%10d|%20s|%20s|%20s|%20d|\n",rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),rs.getInt(5));
                }
            }

            System.out.println("\nEnd of Query Result");

        }catch (SQLException ex) {
            System.out.println("\nCant search and list parts");
        }finally{ // close conn etc

                rs.close();
                pstmt.close();
                conn.close();

                }

    }// end of search and list part

    private static void add_new_transaction() throws SQLException, FileNotFoundException {// ## seems difficult, code later
        
        int sales_ID, item_ID, price, next_id;
        Scanner sc = new Scanner(System.in);

        System.out.print("\nEnter your Sales ID: ");// get sales id input
        while (!sc.hasNextInt()) {
            System.out.print("\nPlease enter valid integer:");
            sc.next();
        }
        sales_ID = sc.nextInt();

        System.out.print("\nEnter your Item ID: ");// get item id input
        while (!sc.hasNextInt()) {
            System.out.print("\nPlease enter valid integer:");
            sc.next();
        }
        item_ID = sc.nextInt();

        if(validity(sales_ID,item_ID)){// if two ID are valid and item quantity > 0
            
            Connection conn = null;
            PreparedStatement pstmt=null;
            Statement stmt=null;
            ResultSet rs =null;

            try {

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);

            stmt = conn.createStatement();
            rs = stmt.executeQuery(proj.Query.GETID);
            if (rs.next()) next_id = rs.getInt(1) + 1;
            else next_id = 1000;
            
            //add transaction 
            pstmt = conn.prepareStatement(proj.Query.ADDTRANSACTION[0]);
            pstmt.setInt(1, next_id);// # how to know transaction ID???
            pstmt.setInt(2, item_ID);
            pstmt.setInt(3, sales_ID);
            pstmt.executeUpdate();

            // update the item quantity
            pstmt = conn.prepareStatement(proj.Query.ADDTRANSACTION[1]);
            pstmt.setInt(1, item_ID);
            pstmt.executeUpdate();

            System.out.println("\nProcessing.....Done");

            // print the item price
            pstmt = conn.prepareStatement(proj.Query.ADDTRANSACTION[2]);
            pstmt.setInt(1, item_ID);
            rs = pstmt.executeQuery();

            if (rs.next()) price = rs.getInt(1);
            else price = 0;

            System.out.printf("Transaction Value: %d\n",price);

            }catch (SQLException ex) { System.out.println("\nCant add transaction");
            }finally{ // close conn etc

                rs.close();
                pstmt.close();
                conn.close();

                }

        }
        else{// ##return to main menu !

            System.out.println("\nReturn to the Main Menu");
            main_menu();

        }

    }// end of add transaction

    private static boolean validity(int sales_ID, int item_ID) throws SQLException{// ok

        boolean status = true;

        Connection conn = null;
        PreparedStatement pstmt=null;
        ResultSet rs =null;

        try{

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);

            //check for sales_ID
            pstmt = conn.prepareStatement(proj.Query.CHECK[0]);
            pstmt.setInt(1,sales_ID);
            rs = pstmt.executeQuery();

            while (rs.next() && status) {
                if (rs.getInt(1) == 0) {
                    System.out.println("\nWarn: Salesperson ID not exist!");
                    status = false;
                }
            }

            //check for item ID
            pstmt = conn.prepareStatement(proj.Query.CHECK[1]);
            pstmt.setInt(1,item_ID);
            rs = pstmt.executeQuery();

            while (rs.next() && status) {
                if (rs.getInt(1) == 0) {
                    System.out.println("\nWarn: Item ID not exist!");
                    status = false;
                }
            }

            //check for item quantity
            pstmt = conn.prepareStatement(proj.Query.CHECK[2]);
            pstmt.setInt(1,item_ID);
            rs = pstmt.executeQuery();

            while (rs.next() && status) {
                if (rs.getInt(1) == 0) {
                    System.out.println("\nWarn: Item is not availble");
                    status = false;
                }
            }

            }catch (SQLException ex) {
                System.out.println("\nWarn: Cant create statement in check availability");
            }finally{ // close conn etc

                    rs.close();
                    pstmt.close();
                    conn.close();

                    }

            return status;

    }// end of check validity

    private static void show_transaction_history() throws SQLException{  //##  bug fixed- mistype '?'

        int number =1;//get user's choice of search criterion

        System.out.println("\nChoose the Search Criterion ");
        System.out.println("1. Salesperson ID");
        System.out.println("2. Part ID");
        System.out.print("Enter your Choice: ");

        Scanner choose = new Scanner(System.in);

        do {// ensure the number from 1 to 3

            if (number <= 0 || number > 2)
                System.out.print("\nUnknown action! Please select again:");

            while (!choose.hasNextInt()) {
                System.out.print("\nUnknown action! Please select again:");
                choose.next(); 
            }
            number = choose.nextInt();
        } while (number <= 0 || number > 2);

        // ## should take integer
        int search = 1;
        Scanner scan = new Scanner(System.in);
        System.out.print("\nType in the Search Key ID: ");
        
        do {
            if (search <= 0 )
                System.out.print("\nInvalid ID! Please input again:");
           
            while (!choose.hasNextInt()) {
                System.out.print("\nInvalid ID! Please input again:");
                choose.next(); 
            }
            search = choose.nextInt();
        } while (search <= 0 );

        Connection conn = null;
        PreparedStatement pstmt=null;
        ResultSet rs =null;
        try {// execute query to search

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
            switch(number){
                case 1:
                    pstmt = conn.prepareStatement(proj.Query.SHOWHISTORY[0]);
                    break;
                case 2:
                    pstmt = conn.prepareStatement(proj.Query.SHOWHISTORY[1]);
                    break;
            }// end of prepare sql statement

            pstmt.setInt(1, search);
            rs = pstmt.executeQuery();//get query result

            System.out.printf("\n|%20s|%10s|%20s|%20s|%20s|%20s|\n", "Transaction ID", "Part ID", "Part Name", "Salesperson ID","Salesperson Name","Date");
            while (rs.next()) {
    
                System.out.printf("|%20d|%10d|%20s|%20d|%20s|%20s|\n",rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getInt(4),rs.getString(5),df.format(rs.getDate(6)));
                
            }//date df.format()

            System.out.println("\nEnd of Query Result");


        }catch (SQLException ex) {
            System.out.println("\nCant show transaction history");
        }finally{ // ## follow this style!

                rs.close();// ## null exception
                pstmt.close();
                conn.close();

                }

    }// end of show_history


    private static void rank_sales_category() throws SQLException{//## java.lang.NullPointerException


        Connection conn = null;
        Statement stmt=null;
        ResultSet rs =null;

        try{

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
            stmt = conn.createStatement();

            stmt.executeUpdate(proj.Query.CREATEVIEW[0]);// ##problem of sql query! since replace with other sql, no bug
            stmt.executeUpdate(proj.Query.CREATEVIEW[1]);

            
            rs = stmt.executeQuery(proj.Query.SHOWSALESRANK);

            // print the query result
            System.out.printf("\n|%20s|%20s|%25s|\n", "Category ID","Category Name", "Total Transcation Value");
            while (rs.next()) {
    
                System.out.printf("|%20d|%20s|%25d|\n",rs.getInt(1), rs.getString(2), rs.getInt(3));
                
            }

            System.out.println("\nEnd of Query Result");

            stmt.executeUpdate(proj.Query.DROPVIEW[0]);//drop temp table
            stmt.executeUpdate(proj.Query.DROPVIEW[1]);

        } catch (SQLException ex) {
            System.out.println("\nCant show sales rank of category");
        }finally{ // ## follow this style!
            
            rs.close();
            stmt.close();
            conn.close();
              

                }
        
    }// end of rank sale by category

    private static void rank_sales_salesperson() throws SQLException{ 

        Connection conn = null;
        Statement stmt=null;
        ResultSet rs =null;

        try{

            conn = DriverManager.getConnection(DB_Url, DB_User, DB_Password);
            stmt = conn.createStatement();

            stmt.executeUpdate(proj.Query.CREATEVIEW[2]);
            stmt.executeUpdate(proj.Query.CREATEVIEW[3]);

            
            rs = stmt.executeQuery(proj.Query.SHOWSALESRANK1);

            // print the query result
            System.out.printf("\n|%20s|%20s|%25s|\n", "Salesperson ID","Salesperson Name", "Total Transcation Value");
            while (rs.next()) {
    
            System.out.printf("|%20d|%20s|%25d|\n",rs.getInt(1), rs.getString(2), rs.getInt(3));
                
            }

            System.out.println("\nEnd of Query Result");

            stmt.executeUpdate(proj.Query.DROPVIEW[0]);//drop temp table
            stmt.executeUpdate(proj.Query.DROPVIEW[1]);


        } catch (SQLException ex) {
            System.out.println("\nCant show sales rank of salesperson");
        }finally{ // close conn etc

                rs.close();
                stmt.close();
                conn.close();

                }
    }// end of rank sale of salesperson

/*--------------------------------------------------Query Data---------------------------------------------------*/

    private static class Query {

        public final static String[] CREATETABLE = {

            "CREATE TABLE category (c_id Integer PRIMARY KEY,c_name varchar2(255))",
            "CREATE TABLE manufacturer (m_id Integer PRIMARY KEY,m_name varchar2(255),m_address varchar2(255),m_phoneno Integer)",
            "CREATE TABLE part (p_id Integer PRIMARY KEY,p_name varchar2(255),p_price Integer,m_id Integer references manufacturer(m_id),c_id Integer references category(c_id),p_aquantity Integer)", 
            "CREATE TABLE salesperson (s_id Integer PRIMARY KEY,s_name varchar2(255),s_address varchar2(255),s_phoneno Integer)",
            "CREATE TABLE transactions (t_id Integer PRIMARY KEY,p_id Integer references part(p_id),s_id Integer references salesperson(s_id),t_date Date)"
         };

        public final static String[] DROPTABLE = {// ok
            "DROP TABLE transactions",
            "DROP TABLE salesperson",
            "DROP TABLE part",
            "DROP TABLE manufacturer",
            "DROP TABLE category"
         };

        public final static String INSERTCATEGORY =
            "INSERT INTO category VALUES(?,?)";

        public final static String INSERTMANUACTURER =
            "INSERT INTO manufacturer VALUES(?,?,?,?)";

        public final static String INSERTPART =
            "INSERT INTO part VALUES(?,?,?,?,?,?)";

        public final static String INSERTSALESPERSONS =
            "INSERT INTO salesperson VALUES(?,?,?,?)";

        public final static String INSERTTRANSACTIONS =
            "INSERT INTO transactions VALUES(?,?,?,to_date(?, 'dd/mm/yyyy'))";
            // to date 
        public final static String[] SEARCHPARTS ={// ok

            "SELECT P.p_id, P.p_name, C.c_name, M.m_name, P.p_aquantity FROM part P, category C, manufacturer M WHERE P.m_id = M.m_id AND P.c_id = C.c_id AND C.c_name LIKE ?",
            "SELECT P.p_id, P.p_name, C.c_name, M.m_name, P.p_aquantity FROM part P, category C, manufacturer M WHERE P.m_id = M.m_id AND P.c_id = C.c_id AND M.m_name LIKE ?",
            "SELECT P.p_id, P.p_name, C.c_name, M.m_name, P.p_aquantity FROM part P, category C, manufacturer M WHERE P.m_id = M.m_id AND P.c_id = C.c_id AND P.p_name LIKE ?"
            };

        public final static String [] SHOWHISTORY ={// ok 

            "SELECT T.t_id, P.p_id, P.p_name, S.s_id, S.s_name, T.t_date FROM transactions T, part P, salesperson S WHERE T.p_id = P.p_id AND T.s_id = S.s_id AND T.s_id = ? ORDER BY T.t_date  DESC",
            "SELECT T.t_id, P.p_id, P.p_name, S.s_id, S.s_name, T.t_date FROM transactions T, part P, salesperson S WHERE T.p_id = P.p_id AND T.s_id = S.s_id AND T.p_id = ? ORDER BY T.t_date  DESC"
            };

        public final static String[] DROPVIEW ={

            "DROP VIEW temp1",
            "DROP VIEW temp2"
            };

        public final static String[] CREATEVIEW = {

            "CREATE OR REPLACE VIEW temp1 AS SELECT T.p_id, COUNT(*) AS soldquantity FROM transactions T GROUP BY T.p_id",
            "CREATE OR REPLACE VIEW temp2 AS SELECT P.c_id, SUM((temp1.soldquantity * P.p_price)) as salesvalue FROM part P LEFT JOIN temp1 on P.p_id = temp1.p_id GROUP BY P.c_id",
            "CREATE OR REPLACE VIEW temp1 AS SELECT T.s_id, T.p_id, P.p_price FROM transactions T, part P WHERE P.p_id = T.p_id",
            "CREATE OR REPLACE VIEW temp2 AS SELECT s_id, SUM(p_price) AS salesvalue FROM temp1 GROUP BY s_id"
            };

        public final static String SHOWSALESRANK = 
            "SELECT C.c_id, C.c_name, temp2.salesvalue FROM category C, temp2 WHERE C.c_id = temp2.c_id ORDER BY temp2.salesvalue ASC";

        public final static String SHOWSALESRANK1 =
            "SELECT S.s_id, S.s_name, temp2.salesvalue FROM salesperson S, temp2 WHERE S.s_id = temp2.s_id ORDER BY temp2.salesvalue ASC";
    
        public final static String[] CHECK = {// seems ok

            "SELECT COUNT(*) FROM salesperson S WHERE S.s_id = ?",//check for salesperson ID
            "SELECT COUNT(*) FROM part P WHERE P.p_id = ?",
            "SELECT P.p_aquantity FROM part P WHERE P.p_id = ?"

            };

        public final static String[] ADDTRANSACTION ={// big problem

            "INSERT INTO transactions VALUES (?,?,?, CURRENT_DATE)",//current data work?
            "UPDATE part SET p_aquantity = p_aquantity - 1 WHERE p_id = ?",
            "SELECT P.p_price FROM part P WHERE P.p_id = ?"

            };

        public final static String GETID = 
            "SELECT MAX(T.t_id) FROM transactions T";

        public final static String[] SHOWTABLE = {

            "SELECT * FROM category",
            "SELECT * FROM manufacturer",
            "SELECT * FROM part",
            "SELECT * FROM salesperson",
            "SELECT * FROM transactions"
        };

    }

}

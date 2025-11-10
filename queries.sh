#!/bin/sh
# This script runs predefined SQL queries from advanced_queries.sql.

# Set the Oracle connection string
sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))" <<EOF

# Function to run all queries from the advanced_queries.sql file
run_advanced_queries() {
    echo "Running all advanced queries from advanced_queries.sql..."
    @advanced_queries.sql
}

# Main Menu for selecting queries
echo "Welcome to the Data Center Query Script!"
echo "Please choose an option:"
echo "1) Run All Advanced Queries"
echo "2) Exit"

while true; do
    echo "Enter your choice:"
    read choice

    case $choice in
        1) run_advanced_queries ;;
        2) echo "Exiting the script."; exit ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done

exit
EOF

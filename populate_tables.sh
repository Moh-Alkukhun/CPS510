#!/bin/sh
# This script allows you to populate the existing tables in the Data Center Database interactively.

# Set the Oracle connection string
sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))" <<EOF

# Function to insert server data
insert_server() {
    echo "Enter server name:"
    read server_name
    echo "Enter server model:"
    read model
    echo "Enter processor type:"
    read processor_type
    echo "Enter RAM (GB):"
    read ram
    echo "Enter storage (GB):"
    read storage
    echo "Enter server status (e.g., Active, Inactive):"
    read status
    echo "Enter server location:"
    read location

    INSERT_QUERY="INSERT INTO SERVERS (server_name, model, processor_type, ram, storage, status, location) 
                  VALUES ('$server_name', '$model', '$processor_type', $ram, $storage, '$status', '$location');"
    echo $INSERT_QUERY | sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
}

# Function to insert performance metrics data
insert_performance_metrics() {
    echo "Enter server ID:"
    read server_id
    echo "Enter metric type (e.g., CPU Usage, RAM Usage):"
    read metric_type
    echo "Enter metric value (e.g., percentage):"
    read metric_value
    echo "Enter timestamp (YYYY-MM-DD HH:MM:SS):"
    read timestamp

    INSERT_QUERY="INSERT INTO PERFORMANCE_METRICS (server_id, metric_type, metric_value, timestamp) 
                  VALUES ($server_id, '$metric_type', $metric_value, TO_TIMESTAMP('$timestamp', 'YYYY-MM-DD HH24:MI:SS'));"
    echo $INSERT_QUERY | sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
}

# Function to insert alerts data
insert_alert() {
    echo "Enter alert type (e.g., CPU Overload, Disk Full):"
    read alert_type
    echo "Enter severity (e.g., Low, Medium, High):"
    read severity
    echo "Enter alert description:"
    read description
    echo "Enter server ID:"
    read server_id
    echo "Enter alert status (e.g., Active, Resolved):"
    read status
    echo "Enter timestamp (YYYY-MM-DD HH:MM:SS):"
    read timestamp

    INSERT_QUERY="INSERT INTO ALERTS (alert_type, severity, description, timestamp, status, server_id) 
                  VALUES ('$alert_type', '$severity', '$description', TO_TIMESTAMP('$timestamp', 'YYYY-MM-DD HH24:MI:SS'), '$status', $server_id);"
    echo $INSERT_QUERY | sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
}

# Function to insert maintenance data
insert_maintenance() {
    echo "Enter maintenance type (e.g., Scheduled, Emergency):"
    read maintenance_type
    echo "Enter server ID:"
    read server_id
    echo "Enter user ID:"
    read user_id
    echo "Enter maintenance status (e.g., Completed, In Progress):"
    read status
    echo "Enter timestamp (YYYY-MM-DD HH:MM:SS):"
    read timestamp
    echo "Enter maintenance notes:"
    read notes

    INSERT_QUERY="INSERT INTO MAINTENANCE (maintenance_type, server_id, user_id, status, timestamp, notes) 
                  VALUES ('$maintenance_type', $server_id, $user_id, '$status', TO_TIMESTAMP('$timestamp', 'YYYY-MM-DD HH24:MI:SS'), '$notes');"
    echo $INSERT_QUERY | sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
}

# Function to insert user data
insert_user() {
    echo "Enter user name:"
    read user_name
    echo "Enter user email:"
    read email
    echo "Enter user role (e.g., Admin, Technician):"
    read role
    echo "Enter access level (e.g., High, Low):"
    read access_level

    INSERT_QUERY="INSERT INTO USERS (user_name, email, role, access_level) 
                  VALUES ('$user_name', '$email', '$role', '$access_level');"
    echo $INSERT_QUERY | sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
}

# Function to insert environmental sensors data
insert_sensor() {
    echo "Enter sensor type (e.g., Temperature, Humidity):"
    read sensor_type
    echo "Enter sensor value:"
    read sensor_value
    echo "Enter sensor location:"
    read location
    echo "Enter timestamp (YYYY-MM-DD HH:MM:SS):"
    read timestamp

    INSERT_QUERY="INSERT INTO ENVIRONMENTAL_SENSORS (sensor_type, sensor_value, location, timestamp) 
                  VALUES ('$sensor_type', $sensor_value, '$location', TO_TIMESTAMP('$timestamp', 'YYYY-MM-DD HH24:MI:SS'));"
    echo $INSERT_QUERY | sqlplus64 "CompSciUsername@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
}

# Main Menu to insert data
echo "Welcome to the Data Center Table Population Script!"
echo "Please choose an option to insert data into a table:"
echo "1) Insert Server Data"
echo "2) Insert Performance Metrics Data"
echo "3) Insert Alerts Data"
echo "4) Insert Maintenance Data"
echo "5) Insert User Data"
echo "6) Insert Environmental Sensors Data"
echo "7) Exit"

while true; do
    echo "Enter your choice:"
    read choice

    case $choice in
        1) insert_server ;;
        2) insert_performance_metrics ;;
        3) insert_alert ;;
        4) insert_maintenance ;;
        5) insert_user ;;
        6) insert_sensor ;;
        7) echo "Exiting the script."; exit ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done

exit
EOF

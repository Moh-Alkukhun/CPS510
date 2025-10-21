#!/bin/sh
sqlplus64 "malkukhu@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.cs.torontomu.ca )( Port=1521))(CONNECT_DATA=(SID=orcl12c)))" <<EOF
@create_tables.sql
exit;
EOF

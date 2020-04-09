sqlplus -s -l sys/dadin041972@//localhost:1521/XE as sysdba <<EOF
    alter session set current_schema = APEX_190100;

	begin
		wwv_flow_security.g_security_group_id := 10;
		wwv_flow_security.g_user              := 'ADMIN';
		wwv_flow_fnd_user_int.create_or_update_user( p_user_id  => NULL,
													 p_username => 'ADMIN',
													 p_email    => 'ADMIN',
													 p_password => 'Mutiara2no4__' );
	 
		DBMS_XDB.sethttpport(8181);
		DBMS_XDB.setlistenerlocalaccess(FALSE);
		COMMIT;
	end;
	/
	
	EXIT;
EOF

	
cd /tmp/apex
sqlplus -s -l sys/dadin041972@//localhost:1521/XE as sysdba <<EOF
@apex_epg_config.sql /tmp
EXIT;
EOF

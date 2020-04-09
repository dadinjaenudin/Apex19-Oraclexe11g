begin
    wwv_flow_security.g_security_group_id := 10;
    wwv_flow_security.g_user              := 'ADMIN';
    wwv_flow_fnd_user_int.create_or_update_user( p_user_id  => NULL,
                                                 p_username => 'ADMIN',
                                                 p_email    => 'ADMIN',
                                                 p_password => 'P@ssword' );
 
	DBMS_XDB.sethttpport(8181);
	DBMS_XDB.setlistenerlocalaccess(FALSE);
	COMMIT;

end;
/

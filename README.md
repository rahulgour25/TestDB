# 
mst_users.sql : it has user table strucure and sequence struncture


set_users.sql : procedure to insert/update/delete pateint for patient you have to pass pi_user_type_id parameter as 1 , 2 is for Doctor
                there are tw output parameter code and message 
                if record successfully saved then po_code will be 1 else in case of any error and validation failed it will return code as 0 and 
                error message 
                There are a flag pi_action if it will pass 'A' the new record will be inserted , in case of 'E' record will be updated in this case 
                user id will be pass
                
                
 get_users.sql : get function to view all the user in JSON forma

SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE VIEW YourInformation2(SerialNo, Name, PhoneNumber, Address, LicenseNumber, LicenseType)
as
(select OID, Name, Phone, Address, LicenseID, LicenseType from OwnerInfo2); 

CREATE OR REPLACE VIEW YourInformation1(SerialNo, Name, PhoneNumber, Address, LicenseNumber, LicenseType)
as
(select OID, Name, Phone, Address, LicenseID, LicenseType from OwnerInfo1@site1); 


CREATE OR REPLACE TRIGGER NewOwnerInsert2
AFTER INSERT
ON OwnerInfo2
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('New Owner Inserted');
END;
/

CREATE OR REPLACE PACKAGE  owner_information AS 

	FUNCTION owner_name_show (oLicenseID IN OwnerInfo2.LicenseID%TYPE)
	RETURN NUMBER;

END owner_information;
/

CREATE OR REPLACE PACKAGE BODY owner_information AS 

	FUNCTION owner_name_show (oLicenseID IN OwnerInfo2.LicenseID%TYPE)
	RETURN NUMBER
	IS 
    Lid1 NUMBER:= 0;
    
    BEGIN

        FOR i IN (select LicenseID from OwnerInfo2)		
            LOOP
                IF( oLicenseID = i.LicenseID) THEN
                Lid1 := 2;
                END IF;
            END LOOP;
        FOR i IN (select LicenseID from OwnerInfo1@site1)		
            LOOP	
                IF( oLicenseID = i.LicenseID) THEN
                Lid1 :=1;
                END IF;
            END LOOP;
        return Lid1;

	END owner_name_show;


	
END owner_information;
/


BEGIN
	DBMS_OUTPUT.PUT_LINE('ARE YOU NEW AT HERE?=YES/NO');
    DBMS_OUTPUT.PUT_LINE('IF YES YOU NEED TO ADD YOUR INFORMATION');
    DBMS_OUTPUT.PUT_LINE('IF No THEN YOU DONT NEED TO ADD ANY THING');
    DBMS_OUTPUT.PUT_LINE('YOU CAN ALSO DELETE YOUR ACCOUNT');
    DBMS_OUTPUT.PUT_LINE('FOR DELETE INSERT DELETE THEN TYPE YOUR License ID NUMBER');
END;
/
ACCEPT owner_status CHAR PROMPT "ARE YOU NEW AT HERE? YES/NO/DELETE: ";
ACCEPT owner_LicenseID CHAR PROMPT "ENTER THE OWNER License NUMBER: ";



DECLARE
    o_status varchar2(20);
    o_LicenseID OwnerInfo2.LicenseID%TYPE;
    License_status NUMBER;
    region_value varchar2(20);
    not_found_exc EXCEPTION;
   
BEGIN
    o_status := '&owner_status';
    o_LicenseID := '&owner_LicenseID';


  --  DBMS_OUTPUT.PUT_LINE(region_value);
    IF(o_status ='NO')  THEN
        License_status := owner_information.owner_name_show(o_LicenseID);       
        IF (License_status = 1 ) THEN           
            for i in (select SerialNo, Name, PhoneNumber, Address, LicenseNumber, LicenseType 
                from YourInformation1 where LicenseNumber = o_LicenseID)loop
                DBMS_OUTPUT.PUT_LINE('SerialNo: '|| i.SerialNo || ' Name: ' 
                || i.Name || ' PhoneNumber: ' || i.PhoneNumber || 'Address: '|| i.Address || ' LicenseNumber: ' 
                || i.LicenseNumber || ' LicenseType: ' || i.LicenseType);           
                end loop;
        elsif (License_status = 2 ) THEN           
            for r in (select SerialNo, Name, PhoneNumber, Address, LicenseNumber, LicenseType 
                from YourInformation2 where LicenseNumber = o_LicenseID)loop
                DBMS_OUTPUT.PUT_LINE('SerialNo: '|| r.SerialNo || ' Name: ' 
                || r.Name || ' PhoneNumber: ' || r.PhoneNumber || 'Address: '|| r.Address || ' LicenseNumber: ' 
                || r.LicenseNumber || ' LicenseType: ' || r.LicenseType);           
                end loop;
        ELSE
            raise not_found_exc;
              
        END IF;

    elsif(o_status ='DELETE')  THEN
        License_status := owner_information.owner_name_show(o_LicenseID);       
        IF (License_status = 1 ) THEN           
            delete from OwnerInfo1@site1
             where LicenseID = o_LicenseID;
        elsif (License_status = 2 ) THEN           
           delete from OwnerInfo2
            where LicenseID = o_LicenseID;
        ELSE
            raise not_found_exc;
              
        END IF;
        
    END IF;
        
EXCEPTION
	WHEN not_found_exc THEN
        BEGIN
			DBMS_OUTPUT.PUT_LINE('License number does not exist');
		END;

END;
/
commit;
SHOW errors
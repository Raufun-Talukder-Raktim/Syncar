SET SERVEROUTPUT ON;
SET VERIFY OFF;

/*CREATE OR REPLACE VIEW YourInformation(SerialNo, Name, PhoneNumber, Address, LicenseNumber, LicenseType) as
select OID.oi2, Name.oi2, Phone.oi2, Address.oi2, LicenseID.oi2, LicenseType.oi2 from OwnerInfo2 oi2 */

CREATE OR REPLACE TRIGGER NewOwnerInsert2
AFTER INSERT
ON OwnerInfo2
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('New Owner Inserted');
END;
/

CREATE OR REPLACE PACKAGE  owner_information AS 

	FUNCTION owner_name_chack (oLicenseID IN OwnerInfo2.LicenseID%TYPE)
	RETURN NUMBER;

END owner_information;
/

CREATE OR REPLACE PACKAGE BODY owner_information AS 

	FUNCTION owner_name_chack (oLicenseID IN OwnerInfo2.LicenseID%TYPE)
	RETURN NUMBER
	IS 
    Lid1 NUMBER:= 0;
    
    BEGIN

        FOR i IN (select LicenseID from OwnerInfo2)		
            LOOP
                IF( oLicenseID = i.LicenseID) THEN
                Lid1 := 1;
                END IF;
            END LOOP;
        FOR i IN (select LicenseID from OwnerInfo1@site1)		
            LOOP	
                IF( oLicenseID = i.LicenseID) THEN
                Lid1 :=1;
                END IF;
            END LOOP;
        return Lid1;

	END owner_name_chack;


	
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
ACCEPT owner_LicenseID CHAR PROMPT "ENTER THE OWNER License ID NUMBER: ";
ACCEPT owner_name CHAR PROMPT "ENTER THE OWNER NAME: ";
ACCEPT owner_phone CHAR PROMPT "ENTER THE OWNER PHONE NUMBER : ";
ACCEPT owner_address CHAR PROMPT "ENTER THE OWNER PERMANENT ADDRESS: ";
ACCEPT owner_LicenseType CHAR PROMPT "ENTER THE OWNER License TYPE: ";


DECLARE
    o_status varchar2(20);
    o_name OwnerInfo2.Name%TYPE;
    o_phone OwnerInfo2.Phone%TYPE;
    o_address OwnerInfo2.Address%TYPE;
    o_LicenseID OwnerInfo2.LicenseID%TYPE;
    o_LicenseType OwnerInfo2.LicenseType%TYPE;

    License_status NUMBER;
    region_value varchar2(20);
    found_exccp EXCEPTION;
   
BEGIN
    o_status := '&owner_status';
    o_name := '&owner_name';
    o_phone := '&owner_phone';
    o_address := '&owner_address';
    o_LicenseID := '&owner_LicenseID';
    o_LicenseType := '&owner_LicenseType'; 

  --  DBMS_OUTPUT.PUT_LINE(region_value);
    IF(o_status ='YES')  THEN
        SELECT Region into region_value FROM RegionMap  WHERE DISTRICT= o_address;
        License_status := owner_information.owner_name_chack(o_LicenseID);
        IF (License_status = 1 ) THEN
            RAISE found_exccp;
        ELSE
            IF(region_value='Chittagong') THEN
                INSERT INTO OwnerInfo2 (Name,Phone,Address,LicenseID,LicenseType) VALUES ( o_name,o_phone,o_address,o_LicenseID,o_LicenseType);
            ELSIF(region_value='Dhaka') THEN
                INSERT INTO OwnerInfo1@site1 (Name,Phone,Address,LicenseID,LicenseType) VALUES ( o_name,o_phone,o_address,o_LicenseID,o_LicenseType);
            END IF;
        END IF;
        
    END IF;

EXCEPTION
	WHEN found_exccp THEN
        BEGIN
			DBMS_OUTPUT.PUT_LINE('OWNER ALREADY EXISTED CHACK YOUR INFORMATION AGAIN');
		END;

END;
/
commit;
SHOW errors
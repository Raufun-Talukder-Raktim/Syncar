SET SERVEROUTPUT ON;
SET VERIFY OFF;
CLEAR SCREEN;

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

	END owner_name_chack;
END owner_information;
/

ACCEPT owner_LicenseID CHAR PROMPT "ENTER THE OWNER License ID NUMBER: ";
ACCEPT owner_name CHAR PROMPT "ENTER THE OWNER NAME: ";
ACCEPT owner_phone CHAR PROMPT "ENTER THE OWNER PHONE NUMBER : ";
ACCEPT owner_address CHAR PROMPT "ENTER THE OWNER PERMANENT ADDRESS: ";


DECLARE
   
    o_name OwnerInfo2.Name%TYPE;
    o_phone OwnerInfo2.Phone%TYPE;
    o_LicenseID OwnerInfo2.LicenseID%TYPE;
    o_address OwnerInfo2.Address%TYPE;
    o_LicenseType OwnerInfo2.LicenseType%TYPE;
    License_status NUMBER;
    region_value varchar2(20);
    found_exccp EXCEPTION;
   
BEGIN
    o_LicenseID := '&owner_LicenseID';
    o_name := '&owner_name';
    o_phone := '&owner_phone';
    o_address := '&owner_address';
 
  --  DBMS_OUTPUT.PUT_LINE(region_value);
   
        SELECT Region into region_value FROM RegionMap  WHERE DISTRICT=o_address;
        License_status := owner_information.owner_name_chack(o_LicenseID);
        IF (License_status = 2 ) THEN
            if (region_value = 'Chittagong' ) then
              update OwnerInfo2
               set Name=o_name,Phone=o_phone
             where LicenseID = o_LicenseID;
            elsif (region_value = 'Dhaka' ) then
                
                select LicenseType
                        into o_LicenseType
                        from OwnerInfo2
                where LicenseID=o_LicenseID;
                
                delete from OwnerInfo2
                 where LicenseID=o_LicenseID;

              INSERT INTO OwnerInfo1@site1 (Name,Phone,Address,LicenseID,LicenseType) 
              VALUES ( o_name,o_phone,o_address,o_LicenseID,o_LicenseType);
            
            end if;

        elsif (License_status = 1 ) THEN
            if (region_value = 'Dhaka' ) then
              update OwnerInfo1@site1
               set Name=o_name,Phone=o_phone
             where LicenseID = o_LicenseID;
            elsif (region_value = 'Chittagong' ) then
                    select LicenseType
                        into o_LicenseType
                        from OwnerInfo1@site1
                    where LicenseID=o_LicenseID;

                delete from OwnerInfo1@site1
                 where LicenseID=o_LicenseID;

              INSERT INTO OwnerInfo2 (Name,Phone,Address,LicenseID,LicenseType) 
              VALUES ( o_name,o_phone,o_address,o_LicenseID,o_LicenseType);
            
            end if;
        else
         raise found_exccp;


        END IF;
        


EXCEPTION
	WHEN found_exccp THEN
        BEGIN
			DBMS_OUTPUT.PUT_LINE('OWNER DoseNot EXISTED CHACK YOUR INFORMATION AGAIN');
		END;

END;
/
commit;
SHOW errors
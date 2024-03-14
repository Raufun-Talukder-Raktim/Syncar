SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for UPDATING Owner Info ---
CREATE OR REPLACE PROCEDURE update_ownerInfo 
    (
        l_LID IN OwnerInfo1.LincenceID%TYPE,
        new_name IN OwnerInfo1.Name%TYPE,
        new_phone IN OwnerInfo1.Phone%TYPE,
        new_address IN OwnerInfo1.Address%TYPE
    ) 
IS
    l_count NUMBER := 0;
    NO_DATA EXCEPTION;

    BEGIN

        SELECT COUNT(LincenceID) INTO l_count
        FROM OwnerInfo1 WHERE LincenceID= l_LID;

        IF l_count > 0 THEN
            UPDATE OwnerInfo1 
            SET Name = new_name, 
                Phone = new_phone, 
                Address = new_address 
            WHERE OID = l_OID;
        ELSE
            SELECT COUNT(LincenceID) INTO l_count
            FROM OwnerInfo2@site2 WHERE LincenceID= l_LID;

            IF l_count > 0 THEN
                UPDATE OwnerInfo2@site2
                SET Name = new_name, 
                    Phone = new_phone, 
                    Address = new_address 
                WHERE OID = l_OID;
            ELSE
                RAISE NO_DATA;
            END IF;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA THEN
        DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THE GIVEN ID!');
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR');
    END update_ownerInfo;
/
SHOW ERROR
COMMIT;

BEGIN
    DECLARE
    l_OID OwnerInfo1.LincenceID%TYPE := &LincenceID;
    new_name OwnerInfo1.Name%TYPE := &NewName;
    new_phone OwnerInfo1.Phone%TYPE := &NewContact;
    new_address OwnerInfo1.Address%TYPE := &NewAddress;
    BEGIN
        update_ownerInfo(l_OID, new_name, new_phone, new_address);
    END;
END;
/
COMMIT;
 
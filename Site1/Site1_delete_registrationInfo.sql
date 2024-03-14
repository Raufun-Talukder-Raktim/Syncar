SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for DELETING entry for Registration Info ---

CREATE OR REPLACE FUNCTION delete_registrationInfo (l_RID IN Registration1.RID%TYPE) 
RETURN Registration1.VIN%TYPE
IS
    l_count NUMBER := 0;
    l_VIN VehicleInfo1.VIN%TYPE;
    NO_DATA EXCEPTION;

BEGIN
    SELECT COUNT(OID) INTO l_count
    FROM Registration1 WHERE RID = l_RID;

    IF l_count > 0 THEN
        SELECT VIN INTO l_VIN
        FROM Registration1 WHERE RID = l_RID;

        DELETE FROM Registration1
        WHERE RID = l_RID;
        
        RETURN l_VIN;
    ELSE
        SELECT COUNT(OID) INTO l_count
        FROM Registration2@site2 WHERE RID = l_RID;

        IF l_count > 0 THEN
            SELECT VIN INTO l_VIN
            FROM Registration2@site2 WHERE RID = l_RID;

            DELETE FROM Registration2@site2
            WHERE RID = l_RID;
            
            RETURN l_VIN;
        ELSE
            RAISE NO_DATA;
        END IF;
    END IF;
    
EXCEPTION
    WHEN NO_DATA THEN
        DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THE GIVEN ID!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR');
END delete_registrationInfo;
/
SHOW ERROR
COMMIT;

-- Taking User Input for DELETING --
BEGIN
    DECLARE
        del_RID Registration1.RID%TYPE := &RegID;
        del_VIN Registration1.VIN%TYPE := 'none';
    BEGIN 
        del_VIN := delete_registrationInfo(del_RID);
        IF NOT(del_VIN = 'none') THEN
            DBMS_OUTPUT.PUT_LINE(CHR(10));
            DBMS_OUTPUT.PUT_LINE('DELETED ENTRY FOR RID ' || del_RID);
        END IF;
    END;
    

END;
/
COMMIT;

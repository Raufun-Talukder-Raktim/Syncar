SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for DELETING entry for Owner Info ---

CREATE OR REPLACE PROCEDURE delete_ownerInfo (l_OID IN OwnerInfo1.OID%TYPE) 
IS
    l_count NUMBER := 0;
    NO_DATA EXCEPTION;

BEGIN
    SELECT COUNT(OID) INTO l_count
    FROM OwnerInfo1 WHERE OID = l_OID;

    IF l_count > 0 THEN
        DELETE FROM OwnerInfo1
        WHERE OID = l_OID;

        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('DELETED ENTRY FOR VIN ' || l_OID);
    ELSE
        SELECT COUNT(OID) INTO l_count
        FROM OwnerInfo2@site2 WHERE OID = l_OID;

        IF l_count > 0 THEN
            DELETE FROM OwnerInfo2@site2
            WHERE OID = l_OID;

            DBMS_OUTPUT.PUT_LINE(CHR(10));
            DBMS_OUTPUT.PUT_LINE('DELETED ENTRY FOR VIN ' || l_OID);
        ELSE
            RAISE NO_DATA;
        END IF;
    END IF;
    
EXCEPTION
    WHEN NO_DATA THEN
    DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THE GIVEN ID!');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR');
END delete_ownerInfo;
/
SHOW ERROR
COMMIT;

-- Taking User Input for DELETING --

BEGIN
    DECLARE
        del_OID OwnerInfo1.OID%TYPE := &OID;
    BEGIN 
        delete_ownerInfo(del_OID);
    END;
END;
/
COMMIT;
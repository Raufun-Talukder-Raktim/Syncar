SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for DELETING entry for Vehicle Info ---

CREATE OR REPLACE FUNCTION delete_vehicleInfo (l_VIN IN VehicleInfo1.VIN%TYPE) 
RETURN VehicleInfo1.OID%TYPE
IS
    l_count NUMBER := 0;
    l_OID VehicleInfo1.OID%TYPE;
    NO_DATA EXCEPTION;
    
BEGIN
    SELECT COUNT(OID) INTO l_count
    FROM VehicleInfo1 WHERE VIN = l_VIN;

    IF l_count > 0 THEN
        SELECT OID INTO l_OID
        FROM VehicleInfo1 WHERE VIN = l_VIN;

        DELETE FROM VehicleInfo1
        WHERE VIN = l_VIN;

        RETURN l_OID;
    ELSE
        SELECT COUNT(OID) INTO l_count
        FROM VehicleInfo2@site2 WHERE VIN = l_VIN;

        IF l_count > 0 THEN
            SELECT OID INTO l_OID
            FROM VehicleInfo2@site2 WHERE VIN = l_VIN;

            DELETE FROM VehicleInfo2@site2
            WHERE VIN = l_VIN;

            RETURN l_OID;
        ELSE
            RAISE NO_DATA;
        END IF;
    END IF;
    
EXCEPTION
    WHEN NO_DATA THEN
    DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THE GIVEN ID!');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR');
END delete_vehicleInfo;
/
SHOW ERROR
COMMIT;

-- Taking User Input for DELETING --
BEGIN
    DECLARE
        del_VIN VehicleInfo1.VIN%TYPE := &VIN;
        del_OID VehicleInfo1.OID%TYPE := -1 ;
    BEGIN 
        del_OID := delete_vehicleInfo(del_VIN);
        IF NOT(del_OID = -1) THEN
            DBMS_OUTPUT.PUT_LINE(CHR(10));
            DBMS_OUTPUT.PUT_LINE('DELETED ENTRY FOR VIN ' || del_VIN);
        END IF;
    END;
    

END;
/
COMMIT;
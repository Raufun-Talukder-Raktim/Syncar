SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for UPDATING Registration Info ---
CREATE OR REPLACE PROCEDURE update_registrationInfo (l_VIN IN VehicleInfo2.VIN%TYPE, l_OID IN OwnerInfo2.OID%TYPE) 
IS
    l_dor Registration2.DoR%TYPE;
    l_condition Registration2.Condition%TYPE;

    l_count NUMBER;

    BEGIN
        l_dor := &NewRegistrationDate;
        l_condition := &VehicleCondition; 

        SELECT COUNT(OID) INTO l_count
        FROM VehicleInfo2 WHERE OID = l_OID AND VIN = l_VIN;

        IF l_count > 0 THEN
            UPDATE VehicleInfo2 
            SET DoR = l_dor, Condition = l_condition
            WHERE OID = owner_id AND VIN = l_VIN;
        ELSE
            SELECT COUNT(OID) INTO l_count
            FROM VehicleInfo2@site1 WHERE OID = l_OID AND VIN = l_VIN;

            IF l_count > 0 THEN
                UPDATE VehicleInfo1@site1 
                SET DoR = l_dor, Condition = l_condition
                WHERE OID = owner_id AND VIN = l_VIN;
            ELSE
                RAISE NO_DATA;
            END IF;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA THEN
        DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THE GIVEN ID!');
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR');
    END update_registrationInfo;
/
SHOW ERROR
COMMIT;
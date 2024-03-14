SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for UPDATING Registration Info ---
CREATE OR REPLACE PROCEDURE update_registrationInfo (l_VIN IN VehicleInfo1.VIN%TYPE, l_OID IN OwnerInfo1.OID%TYPE) 
IS
    l_dor Registration1.DoR%TYPE;
    l_condition Registration1.Condition%TYPE;

    l_count NUMBER;

    BEGIN
        -- ACCEPT new_brand_name PROMPT 'New Brand Name: ';
        -- ACCEPT new_model PROMPT 'New Model: ';
        -- ACCEPT new_yoa PROMPT 'New Year of Assembly: ';
        -- ACCEPT new_purchase_date PROMPT 'New Purchase Date: ';
        -- ACCEPT new_vehicle_type PROMPT 'New Vehicle Type: ';
        -- ACCEPT new_description PROMPT 'New Description: ';

        l_dor := &NewRegistrationDate;
        l_condition := &VehicleCondition; 

        SELECT COUNT(OID) INTO l_count
        FROM VehicleInfo1 WHERE OID = l_OID AND VIN = l_VIN;

        IF l_count > 0 THEN
            UPDATE VehicleInfo1 
            SET DoR = l_dor, Condition = l_condition
            WHERE OID = owner_id AND VIN = l_VIN;
        ELSE
            SELECT COUNT(OID) INTO l_count
            FROM VehicleInfo1@site2 WHERE OID = l_OID AND VIN = l_VIN;

            IF l_count > 0 THEN
                UPDATE VehicleInfo2@site2 
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
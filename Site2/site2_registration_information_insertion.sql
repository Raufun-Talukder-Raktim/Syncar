SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for INSERTING Registration Info ---
CREATE OR REPLACE PROCEDURE insert_registrationInfo 
    (
        l_VIN IN VehicleInfo2.VIN%TYPE, 
        l_OID IN OwnerInfo2.OID%TYPE,
        l_plate_id Registration2.PlateID%TYPE,
        l_dor Registration2.DoR%TYPE,
        l_region Registration2.Region%TYPE,
        l_condition Registration2.Condition%TYPE 
    ) 
IS
    INVALID_REGION EXCEPTION;
    BEGIN
        IF l_region = 'Dhaka' THEN
        DBMS_OUTPUT.PUT_LINE('HERE');
            INSERT INTO Registration2 (VIN, OID, PlateID, DoR, Region, Condition) 
            VALUES (l_VIN, l_OID, l_plate_id, l_dor, l_region, l_condition);
        ELSIF l_region = 'Chittagong' THEN
            INSERT INTO Registration1@site1 (VIN, OID, PlateID, DoR, Region, Condition) 
            VALUES (l_VIN, l_OID, l_plate_id, l_dor, l_region, l_condition);
        ELSE 
            RAISE INVALID_REGION;
        END IF;
    EXCEPTION
        WHEN INVALID_REGION THEN 
            DBMS_OUTPUT.PUT_LINE('Invalid Region!');
        -- WHEN OTHERS THEN
        --     DBMS_OUTPUT.PUT_LINE('ERROR During Insertion!');
    END insert_registrationInfo;
/
SHOW ERROR
COMMIT;

-- Taking User Input for INSERTION and showing changes --
BEGIN
    DECLARE
        l_OID OwnerInfo2.OID%TYPE := &OID;
        l_VIN VehicleInfo2.VIN%TYPE := &VIN;
        l_plate_id Registration2.PlateID%TYPE := &PlateNumber;
        l_dor Registration2.DoR%TYPE := &RegistrationDate;
        l_region Registration2.Region%TYPE := &RegistrationRegion;
        l_condition Registration2.Condition%TYPE := &VehicleCondition;
        
    BEGIN
        insert_registrationInfo(l_VIN, l_OID, l_plate_id, l_dor, l_region, l_condition);
        BEGIN
        ShowInfo.Registration;
        END;
    END;
END;
/
COMMIT;



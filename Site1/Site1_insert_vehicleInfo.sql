SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for INSERTING Vehicle Info ---
CREATE OR REPLACE FUNCTION insert_vehicleInfo 
    (
        l_OID IN OwnerInfo1.Name%TYPE, 
        l_VIN VehicleInfo1.VIN%TYPE,
        l_brand_name VehicleInfo1.BrandName%TYPE,
        l_model VehicleInfo1.Model%TYPE,
        l_yoa VehicleInfo1.YOA%TYPE,
        l_purchase_date VehicleInfo1.PurchaseDate%TYPE,
        l_vehicle_type VehicleInfo1.VehicleType%TYPE,
        l_description VehicleInfo1.Description%TYPE,
        l_region RegionMap.Region%TYPE
    ) 
RETURN VehicleInfo1.VIN%TYPE
IS
    INVALID_REGION EXCEPTION;
    BEGIN
        IF l_region = 'Dhaka' THEN
            INSERT INTO VehicleInfo1 (VIN, OID, BrandName, Model, YOA, PurchaseDate, VehicleType, Description) 
            VALUES (l_VIN, l_OID, l_brand_name, l_model, l_yoa, l_purchase_date, l_vehicle_type, l_description);
        ELSIF l_region = 'Chittagong' THEN
            INSERT INTO VehicleInfo2@site2 (VIN, OID, BrandName, Model, YOA, PurchaseDate, VehicleType, Description) 
            VALUES (l_VIN, l_OID, l_brand_name, l_model, l_yoa, l_purchase_date, l_vehicle_type, l_description);
        ELSE
            RAISE INVALID_REGION;
        END IF;

        RETURN l_VIN; 
    EXCEPTION
        WHEN INVALID_REGION THEN 
            DBMS_OUTPUT.PUT_LINE('Invalid Region!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR!');
    END insert_vehicleInfo;
/
SHOW ERROR
COMMIT;

-- Taking User Input for INSERTION and showing changes --
BEGIN
    DECLARE
    l_OID OwnerInfo1.OID%TYPE := &OID; 
    FLAG OwnerInfo1.OID%TYPE := -1;
    l_region RegionMap.Region%TYPE := &region;
    l_VIN VehicleInfo1.VIN%TYPE := &VehicleID;
    l_brand_name VehicleInfo1.BrandName%TYPE := &BrandName;
    l_model VehicleInfo1.Model%TYPE := &Model;
    l_yoa VehicleInfo1.YOA%TYPE := &YearOfAssembly;
    l_purchase_date VehicleInfo1.PurchaseDate%TYPE := &DateOfPurchase;
    l_vehicle_type VehicleInfo1.VehicleType%TYPE := &VehicleType;
    l_description VehicleInfo1.Description%TYPE := &Description;
        
    BEGIN
        SELECT OID INTO FLAG FROM OwnerInfo1 WHERE OID = l_OID;
        IF FLAG != -1 THEN
            l_VIN := insert_vehicleInfo(l_OID, l_VIN, l_brand_name, l_model, l_yoa, l_purchase_date, l_vehicle_type, l_description, l_region);
            BEGIN
                ShowInfo.Vehicle;
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('INVALID OWNER ID!');
        END IF;
    END;
END;
/
COMMIT;


-- '1'
-- 'Dhaka'
-- '0000000001'
-- 'Tesla'
-- 'Model S'
-- '2012'
-- '01-FEB-2013'
-- 'Electric'
-- 'N/A'

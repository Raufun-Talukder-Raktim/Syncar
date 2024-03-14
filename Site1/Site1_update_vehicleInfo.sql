SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for UPDATING Vehicle Info ---
CREATE OR REPLACE PROCEDURE update_vehicleInfo (l_OID IN OwnerInfo1.Name%TYPE, l_VIN IN VehicleInfo1.Name%TYPE) 
IS
    new_brand_name VehicleInfo1.BrandName%TYPE;
    new_model VehicleInfo1.Model%TYPE;
    new_yoa VehicleInfo1.YOA%TYPE;
    new_purchase_date VehicleInfo1.PurchaseDate%TYPE;
    new_vehicle_type VehicleInfo1.VehicleType%TYPE;
    new_description VehicleInfo1.Description%TYPE;

    l_count NUMBER;

    BEGIN
        -- ACCEPT new_brand_name PROMPT 'New Brand Name: ';
        -- ACCEPT new_model PROMPT 'New Model: ';
        -- ACCEPT new_yoa PROMPT 'New Year of Assembly: ';
        -- ACCEPT new_purchase_date PROMPT 'New Purchase Date: ';
        -- ACCEPT new_vehicle_type PROMPT 'New Vehicle Type: ';
        -- ACCEPT new_description PROMPT 'New Description: ';

        new_brand_name := &NewBrandName;
        new_model := &NewModel;
        new_yoa := &NewYearOfAssembly;
        new_purchase_date := &NewDateOfPurchase;
        new_vehicle_type := &NewVehicleType;
        new_description := &NewDescription;

        SELECT COUNT(OID) INTO l_count
        FROM VehicleInfo1 WHERE OID = l_OID AND VIN = l_VIN;

        IF l_count > 0 THEN
            UPDATE VehicleInfo1 
            SET BrandName = new_brand_name, 
                Model = new_model, 
                YOA = new_yoa, 
                PurchaseDate = new_purchase_date, 
                VehicleType = new_vehicle_type, 
                Description = new_description
            WHERE OID = owner_id AND VIN = l_VIN;
        ELSE
            SELECT COUNT(OID) INTO l_count
            FROM VehicleInfo1@site2 WHERE OID = l_OID AND VIN = l_VIN;

            IF l_count > 0 THEN
                UPDATE VehicleInfo2@site2
                SET BrandName = new_brand_name, 
                    Model = new_model, 
                    YOA = new_yoa, 
                    PurchaseDate = new_purchase_date, 
                    VehicleType = new_vehicle_type, 
                    Description = new_description
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
    END update_vehicleInfo;
/
SHOW ERROR
COMMIT;

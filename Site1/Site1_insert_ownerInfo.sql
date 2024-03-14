SET SERVEROUTPUT ON;
SET VERIFY OFF;

--- Procedure for INSERTING Owner Info ---
CREATE OR REPLACE FUNCTION insert_ownerInfo 
    (
        l_region RegionMap.Region%TYPE,
        l_name OwnerInfo1.Name%TYPE,
        l_phone OwnerInfo1.Phone%TYPE,
        l_address OwnerInfo1.Address%TYPE,
        l_licenseID OwnerInfo1.LicenseID%TYPE,
        l_licenseType OwnerInfo1.LicenseType%TYPE

    )
RETURN OwnerInfo1.OID%TYPE 
IS
    l_OID OwnerInfo1.OID%TYPE;
    INVALID_ADDRESS EXCEPTION;

    BEGIN
        IF l_region = 'Dhaka' THEN
            INSERT INTO OwnerInfo1 (Name, Phone, Address, LicenseID, LicenseType) 
            VALUES (l_name, l_phone, l_address, l_licenseID, l_licenseType);
            SELECT SEQ_OID.NEXTVAL INTO l_OID FROM dual;
        ELSIF l_region = 'Chittagong' THEN
            INSERT INTO OwnerInfo2@site2 (Name, Phone, Address, LicenseID, LicenseType) 
            VALUES (l_name, l_phone, l_address, l_licenseID, l_licenseType);
            SELECT SEQ_OID.NEXTVAL INTO l_OID FROM dual@site2; 
        ELSE
            RAISE INVALID_ADDRESS;
        END IF;

        RETURN l_OID;
    EXCEPTION
        WHEN INVALID_ADDRESS THEN
            DBMS_OUTPUT.PUT_LINE('District not in speified region!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR During Insertion!');
    END insert_ownerInfo;
/
SHOW ERROR
COMMIT;

-- Taking User Input for INSERTION and showing changes --
BEGIN
    DECLARE
        l_region RegionMap.Region%TYPE;
        l_OID OwnerInfo1.OID%TYPE;

        l_name OwnerInfo1.Name%TYPE := &Name;
        l_phone OwnerInfo1.Phone%TYPE := &Phone;
        l_house VARCHAR2(10) := &houseNo;
        l_road VARCHAR2(10) := &roadNo;
        l_PS VARCHAR2(10) := &policeStation;
        l_district VARCHAR2(10) := &district;
        l_address OwnerInfo1.Address%TYPE := l_house || ', ' || l_road || ', ' || l_PS || ', ' || l_district;
        l_licenseID OwnerInfo1.LicenseID%TYPE := &LicenseID;
        l_licenseType OwnerInfo1.LicenseType%TYPE := &LicenseType;
        
    BEGIN
        SELECT Region INTO l_region FROM RegionMap WHERE District = l_district;
        l_OID := insert_ownerInfo(l_region, l_name, l_phone, l_address, l_licenseID, l_licenseType);
        BEGIN
        ShowInfo.Owner;
        END;
    END;
END;
/
COMMIT;


-- 'Ashiq'
-- '0192501510'
-- '1008'
-- 'Rd 2'
-- 'Khilgaon'
-- 'Dhaka'
-- '190104140'
-- 'Professional'
CREATE OR REPLACE FUNCTION INSERT_CTL
RETURN OwnerInfo2.OID%TYPE 
IS

    l_region RegionMap.Region%TYPE;
    l_OID OwnerInfo2.OID%TYPE;

    l_name OwnerInfo2.Name%TYPE := &Name;
    l_phone OwnerInfo2.Phone%TYPE := &Phone;
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
        RETURN l_OID;
    END INSERT_CTL;
/
COMMIT;
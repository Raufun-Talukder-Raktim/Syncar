SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET LINES 150;
SET TRIMOUT ON;
SET TAB OFF;
CLEAR SCREEN;

DROP TABLE OwnerInfo2 CASCADE CONSTRAINTS;
DROP TABLE OwnerInfo2;
DROP TABLE VehicleInfo2 CASCADE CONSTRAINTS;
DROP TABLE VehicleInfo2;
DROP TABLE Registration2 CASCADE CONSTRAINTS;
DROP TABLE Registration2;
DROP TABLE RegionMap CASCADE CONSTRAINTS;
DROP TABLE RegionMap;
DROP SEQUENCE SEQ_OID;
DROP SEQUENCE SEQ_RID;


----CREATING TABLE-----

CREATE TABLE OwnerInfo2 (
    OID INTEGER NOT NULL,
    Name VARCHAR2(20),
    Phone VARCHAR2(17),
    Address VARCHAR2(30),
    LicenseID VARCHAR2(16),
    LicenseType VARCHAR2(12),
    CONSTRAINT PK_OWNER_INFO PRIMARY KEY (OID)
);

CREATE TABLE VehicleInfo2 (
    VIN VARCHAR2(17) NOT NULL,
    OID INTEGER NOT NULL,
    BrandName VARCHAR2(20),
    Model VARCHAR2(20),
    YOA INTEGER,
    PurchaseDate DATE,
    VehicleType VARCHAR2(10),
    Description VARCHAR2(100),
    CONSTRAINT PK_VEHICLE_INFO PRIMARY KEY (VIN),
    CONSTRAINT FK_V_OID FOREIGN KEY (OID) REFERENCES OwnerInfo2(OID)
);

CREATE TABLE Registration2(
	RID INTEGER NOT NULL,
	VIN VARCHAR2(17) NOT NULL,
	OID INTEGER NOT NULL,
	PlateID VARCHAR2(20),
	DoR DATE,
	Region VARCHAR2(10),
	Condition VARCHAR2(50),
	CONSTRAINT PK_REGISTRATION PRIMARY KEY (RID),
	CONSTRAINT FK_R_VIN FOREIGN KEY (VIN) REFERENCES VehicleInfo2(VIN),
	CONSTRAINT FK_R_OID FOREIGN KEY (OID) REFERENCES OwnerInfo2(OID)
);

CREATE TABLE RegionMap (
	District VARCHAR2(20),
	Region VARCHAR2(10)
); 


------ CREATING VIEWS ------
---VIEW FOR OWNERINFO TABLE---
CREATE or REPLACE VIEW Owner_Information AS
    SELECT * FROM (
        SELECT OID AS OwnerID, Name AS OwnerName, Phone AS ContactNumber, Address AS RegisteredAddress, LicenseID AS LicenseNumber, LicenseType AS Grade 
        FROM OwnerInfo1@SITE1 UNION SELECT * from OwnerInfo2
        ORDER BY OwnerID DESC
    ) WHERE ROWNUM <= 5;

--- VIEW FOR VEHCALINFO TABLE---
CREATE or REPLACE VIEW Vehicle_Information AS
    SELECT * FROM (
        SELECT VIN AS VehicleIDNumber, OID AS OwnerID, BrandName AS BrandName, Model AS VehicleModel, YOA AS YearOfAssembly, PurchaseDate AS DateOfPurchase, VehicleType AS VehicleCategory, Description AS VehicleDescription
        FROM VehicleInfo1@SITE1 UNION SELECT * from VehicleInfo2
        ORDER BY VehicleIDNumber DESC
    ) WHERE ROWNUM <= 5;

--- VIEW FOR REGISTRATION TABLE ---
CREATE or REPLACE VIEW Registration_Information AS
    SELECT * FROM (
        SELECT RID AS RegistrationID, VIN AS VehicleIDNumber, OID AS OwnerID, PlateID AS PlateNumber, DoR AS DateofReg, Region AS Reg_Region, Condition AS VehicleCondition
        FROM Registration1@SITE1 UNION SELECT * from Registration2
        ORDER BY RegistrationID DESC
    ) WHERE ROWNUM <= 5;




--- SEQUENCES ---
CREATE SEQUENCE SEQ_OID START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_RID START WITH 1 INCREMENT BY 1;

----TRIGGERS----

-- TRIGGER FOR AUTOINCREMENT IN OWNER INFO --
CREATE OR REPLACE TRIGGER TRIG_OID 
BEFORE INSERT ON OwnerInfo2
FOR EACH ROW
BEGIN
    SELECT SEQ_OID.NEXTVAL INTO :new.OID FROM dual;
    DBMS_OUTPUT.PUT_LINE('Inserting info for ID: ' || :new.OID);
END;
/

-- TRIGGER FOR AUTOINCREMENT IN REGISTRATION --
CREATE OR REPLACE TRIGGER TRIG_RID 
BEFORE INSERT ON Registration2 
FOR EACH ROW
BEGIN
    SELECT SEQ_RID.NEXTVAL INTO :new.RID FROM dual;
    DBMS_OUTPUT.PUT_LINE('Inserting info for ID: ' || :new.RID);
END;
/


---OUTPUT SHOW---

-- FOR OWNERINFO --
BEGIN
    FOR I IN (SELECT * FROM Owner_Information)
    LOOP
        DBMS_OUTPUT.PUT_LINE(I.OwnerID || ' ' || I.OwnerName 
        || ' ' || I.ContactNumber || ' ' || I.RegisteredAddress|| ' ' || I.LicenseNumber ||
         ' ' || I.Grade); 
    END LOOP;
END;
/

-- FOR REGISTRATION --
BEGIN
    FOR I IN (SELECT * FROM Vehicle_Information)
    LOOP
        DBMS_OUTPUT.PUT_LINE(I.VehicleIDNumber || ' ' || I.OwnerID || ' ' || I.BrandName || ' ' || I.VehicleModel|| ' ' || I.YearOfAssembly || ' ' || I.DateOfPurchase || ' ' || I.VehicleCategory || ' ' ||I.VehicleDescription); 
    END LOOP;
END;
/

-- FOR REGISTRATION --
BEGIN
    FOR I IN (SELECT * FROM Registration_Information)
    LOOP
        DBMS_OUTPUT.PUT_LINE(I.RegistrationID || ' ' || I.VehicleIDNumber || ' ' || I.OwnerID || ' ' || I.PlateNumber|| ' ' || I.DateofReg || ' ' || I.Reg_Region || ' ' || I.VehicleCondition); 
    END LOOP;
END;
/


insert into regionmap values ('Dhaka','Dhaka');
insert into regionmap values ('Gazipur','Dhaka');
insert into regionmap values ('Narayanganj','Dhaka');

insert into regionmap values ('Chittagong','Chittagong');
insert into regionmap values ('Feni','Chittagong');
insert into regionmap values ('Faridpur','Chittagong');


-- INSERT INTO OwnerInfo1 (Name, Phone, Address, LicenseID, LicenseType) VALUES ('Raufun ', '01703374073', 'Dhaka', '190104151', 'Reguler');
-- INSERT INTO OwnerInfo1 (Name, Phone, Address, LicenseID, LicenseType) VALUES ('Ashiqul ', '01992501519', 'Dhaka', '190104140', 'Professional');
-- INSERT INTO OwnerInfo1 (Name, Phone, Address, LicenseID, LicenseType) VALUES ('Swapnil ', '01979912890', 'Dhaka', '190104143', 'Professional');

-- INSERT INTO VehicleInfo1 (VIN, OID, BrandName, Model, YOA, PurchaseDate, VehicleType, Description) VALUES ('123456789', 1, 'Toyota', 'Corolla', 2010, TO_DATE('2022-01-31', 'YYYY-MM-DD'), 'Sedan', 'N/A');
-- INSERT INTO VehicleInfo1 (VIN, OID, BrandName, Model, YOA, PurchaseDate, VehicleType, Description) VALUES ('123456000', 2, 'Audi', 'R8', 2012, TO_DATE('2022-01-31', 'YYYY-MM-DD'), 'Sports', 'N/A');

-- INSERT INTO Registration1 (VIN, OID, PlateID, DoR, Region, Condition) VALUES ('123456789', 1, 'Dha-1-2-3', TO_DATE('2022-01-31', 'YYYY-MM-DD'), 'Dhaka', 'N/A');
-- INSERT INTO Registration1 (VIN, OID, PlateID, DoR, Region, Condition) VALUES ('123456000', 2, 'Dha-2-3-4', TO_DATE('2022-01-31', 'YYYY-MM-DD'), 'Chittagong', 'N/A');


-- SELECT * FROM OwnerInfo2
-- SELECT * FROM VehicleInfo2
-- SELECT * FROM Registration2

-- SELECT * FROM OwnerInfo1@site1 UNION SELECT * FROM OwnerInfo2
-- SELECT * FROM VehicleInfo1@site1 UNION SELECT * FROM VehicleInfo2
-- SELECT * FROM Registration1@site1 UNION SELECT * FROM Registration2



COMMIT;
show errors
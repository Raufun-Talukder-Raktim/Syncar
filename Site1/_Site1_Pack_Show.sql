
SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PACKAGE ShowInfo AS
    PROCEDURE Owner;
    PROCEDURE Vehicle;
    PROCEDURE Registration;
END ShowInfo;
/
SHOW ERROR

CREATE OR REPLACE PACKAGE BODY ShowInfo AS
    PROCEDURE Owner
	IS
	BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Recent Changes of Owner Information...');
        FOR I IN (SELECT * FROM Owner_Information)
        LOOP
            DBMS_OUTPUT.PUT_LINE(I.OwnerID || CHR(9) || I.OwnerName || CHR(9) || I.ContactNumber || CHR(9) || I.RegisteredAddress || CHR(9) || I.LicenseNumber || CHR(9) || I.Grade ); 
        END LOOP;    
        DBMS_OUTPUT.PUT_LINE(CHR(10));
    END Owner;

    PROCEDURE Vehicle
	IS
	BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Recent Changes of Owner Information...');
        FOR I IN (SELECT * FROM Vehicle_Information)
        LOOP
            DBMS_OUTPUT.PUT_LINE(I.VehicleIDNumber || CHR(9) || I.OwnerID || CHR(9) || I.BrandName || CHR(9) || I.VehicleModel || CHR(9) ||  I.YearOfAssembly || CHR(9) ||  I.DateOfPurchase || CHR(9) || I.VehicleCategory || CHR(9) || I.VehicleDescription);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
    END Vehicle;

    PROCEDURE Registration
	IS
	BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Recent Changes of Owner Information...');
        FOR I IN (SELECT * FROM Registration_Information)
        LOOP
            DBMS_OUTPUT.PUT_LINE(I.RegistrationID || CHR(9) || I.VehicleIDNumber || CHR(9) || I.OwnerID || CHR(9) || I.PlateNumber || CHR(9) || I.DateofReg|| CHR(9) || I.Reg_Region || CHR(9) || I.VehicleCondition); 
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
	END Registration;
END ShowInfo;
/
SHOW ERROR
COMMIT;

BEGIN
    ShowInfo.Owner;
    ShowInfo.Vehicle;
    ShowInfo.Registration;
END;
/
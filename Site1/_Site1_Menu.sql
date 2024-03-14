-- MAIN BLOCK STARTS HERE 
SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF

BEGIN
    DBMS_OUTPUT.PUT_LINE('1. Insert Information');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '1. Owner');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '2. Vehicle');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '3. Registration');
    DBMS_OUTPUT.PUT_LINE('2. Update Information');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '1. Owner');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '2. Vehicle');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '3. Registration');
    DBMS_OUTPUT.PUT_LINE('3. Delete Information');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '1. Owner');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '2. Vehicle');
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '3. Registration');
    DBMS_OUTPUT.PUT_LINE('4. View Information');
    DBMS_OUTPUT.PUT_LINE('5. Exit');
    DBMS_OUTPUT.PUT_LINE('If you want to $Delete then put ID otherwise put -1..');
END;
/

DECLARE
  opt INTEGER;
  opt_table INTEGER;
--   opt_delete INTEGER := &deleteID;

  m_oid OwnerInfo1.OID%TYPE;
  m_vin VehicleInfo1.VIN%TYPE;
  
BEGIN
    LOOP
        opt := -1;
        opt_table := -1;
      
        opt := &Option;
        opt_table := &TableChoice;
        IF opt = 1 THEN
            IF opt_table = 1 THEN 
                m_oid := INSERT_CTL;
                -- DBMS_OUTPUT.PUT_LINE(m_oid);   
            ELSIF opt_table = 2 THEN
                NULL;
                -- m_oid := insert_ownerInfo();
                -- DBMS_OUTPUT.PUT_LINE(m_oid);
                -- m_vin := insert_vehicleInfo();
                -- DBMS_OUTPUT.PUT_LINE(m_vin);
            ELSIF opt_table = 3 THEN
                NULL;
                -- m_oid := insert_ownerInfo();
                -- DBMS_OUTPUT.PUT_LINE(m_oid);
                -- m_vin := insert_vehicleInfo();
                -- DBMS_OUTPUT.PUT_LINE(m_vin);
                -- insert_registrationInfo(m_vin, m_oid);
            END IF;
        ELSIF opt = 3 THEN
            IF opt_table = 1 THEN
                NULL;
                -- delete_ownerInfo(opt_delete); 
            ELSIF opt_table = 2 THEN
                NULL;
                -- opt_delete := delete_VehicleInfo(opt_delete);
            ELSIF opt_table = 3 THEN
                NULL;
            --    opt_delete := delete_registrationInfo(opt_delete);
            END IF;
        ELSE
            EXIT;
        END IF;
    END LOOP;
    EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input. Try again.');
END;
/
COMMIT;



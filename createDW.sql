
--Esquema estrella
DROP TABLE FACT_SALE;
--Creacion de las tablas de dimension
DROP TABLE DIM_PRODUCT;
DROP TABLE DIM_STORE;
DROP TABLE DIM_CUSTOMER;
DROP TABLE DIM_SUPPLIER;
DROP TABLE DIM_DATE;

--Creando las tablas para sus dimensiones respectivas
CREATE TABLE DIM_PRODUCT
  (
    PRODUCT_ID      VARCHAR2(6),
    PRODUCT_NAME    VARCHAR2(30) NOT NULL,
    CONSTRAINT PRODUCT_PK PRIMARY KEY (PRODUCT_ID)
  );
  
CREATE TABLE DIM_STORE
  (
    STORE_ID      VARCHAR2(4),
    STORE_NAME    VARCHAR2(20) NOT NULL,
    CONSTRAINT STORE_PK PRIMARY KEY (STORE_ID)
  );
  
CREATE TABLE DIM_CUSTOMER
  (
    CUSTOMER_ID      VARCHAR2(4),
    CUSTOMER_NAME    VARCHAR2(30),
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (CUSTOMER_ID)
  );

CREATE TABLE DIM_SUPPLIER
  (
    SUPPLIER_ID      VARCHAR2(5),
    SUPPLIER_NAME    VARCHAR2(30),
    CONSTRAINT SUPPLIER_PK PRIMARY KEY (SUPPLIER_ID)
  );
  CREATE TABLE DIM_DATE
  (
    T_CDATE VARCHAR2(8 BYTE),
    T_DATE DATE,
    T_YEAR    NUMBER(10,0),
    T_QUARTER NUMBER(10,0),
    T_MONTH   CHAR(10 BYTE),
    T_DAY     NUMBER(10,0),
    CONSTRAINT date_pk PRIMARY KEY (T_DATE)
  );  
  
CREATE TABLE FACT_SALE
  (
    CUSTOMER_ID   VARCHAR2(4),
    STORE_ID      VARCHAR2(4),
    SUPPLIER_ID   VARCHAR2(5), 
    PRODUCT_ID    VARCHAR2(6),
    TOTAL_SALE	  NUMBER(5,2),
    T_DATE		  DATE,
    PRICE         NUMBER(5,2) DEFAULT 0.0,
    QUANTITY      NUMBER(3,0) DEFAULT 0.0,
    CONSTRAINT SALE_STORE_FK FOREIGN KEY (STORE_ID) REFERENCES DIM_STORE (STORE_ID),
    CONSTRAINT SALE_SUPPLIER_FK FOREIGN KEY (SUPPLIER_ID) REFERENCES DIM_SUPPLIER (SUPPLIER_ID),
    CONSTRAINT SALE_PRODUCT_FK FOREIGN KEY (PRODUCT_ID) REFERENCES DIM_PRODUCT (PRODUCT_ID),
    CONSTRAINT SALE_DATE_FK FOREIGN KEY (T_DATE) REFERENCES DIM_DATE (T_DATE),
    CONSTRAINT SALE_CUSTOMER_FK FOREIGN KEY (CUSTOMER_ID) REFERENCES DIM_CUSTOMER (CUSTOMER_ID)
   
  );
  

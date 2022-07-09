create or replace PROCEDURE INLJ AS 
Type lst_cur is ref cursor;
v_lst_cur lst_cur;
v_lst_cur_rec transactions%rowtype;
rcd_50 varchar2(300);
rcd number;
--Guardar la master data 
v_pid masterdata.product_id%type;
v_pname masterdata.product_name%type;
v_sid masterdata.supplier_id%type;
v_sname masterdata.supplier_name%type;
v_price masterdata.price%type;
--Aqui aplicamos la limpieza de datos para evitar datos duplicados
t_pid int;
t_suid int;
t_did int;
t_stid int;
t_cid int;
t_fact_sale int;
--Comienza el ciclo
begin
	rcd :=1;
  While (rcd <= 10000)
  loop
      rcd_50 :='select * from transactions where transaction_id between '
                ||to_char(rcd)|| ' and '||to_char(rcd+49);
      open v_lst_cur for rcd_50;
      loop
        fetch v_lst_cur into v_lst_cur_rec;
        exit when v_lst_cur%notfound;
        --Se guarda la informacion en la master data
        select product_id, product_name, supplier_id, supplier_name, price 
                into v_pid, v_pname, v_sid, v_sname, v_price 
                from masterdata where product_id = v_lst_cur_rec.product_id;   
--Si la tabla de la dimension tiene datos, se guarda automaticamente en las 2
--Dimension producto
select count(0) into t_pid from dim_product 
    where product_id = v_lst_cur_rec.product_id ;
      if t_pid =0 then 
          insert into dim_product (product_id,product_name) 
                values (v_lst_cur_rec.product_id, v_pname);
      end if;
--Dimension vendedor
select count(0) into t_suid from dim_supplier  where supplier_id = v_sid ;
      if t_suid =0 then 
          insert into dim_supplier (supplier_id,supplier_name) 
          values (v_sid, v_sname);
      end if;
--Dimension tienda
 select count(0) into t_stid from dim_store  
                            where store_id = v_lst_cur_rec.store_id ;
        if t_stid =0 then 
          insert into dim_store(store_id,store_name) 
          values (v_lst_cur_rec.store_id, v_lst_cur_rec.store_name);
        end if;
--Dimension cliente
 select count(0) into t_cid from dim_customer 
        where customer_id = v_lst_cur_rec.customer_id ;
      if t_cid =0 then 
            insert into dim_customer(customer_id,customer_name) 
            values (v_lst_cur_rec.customer_id, v_lst_cur_rec.customer_name);
      end if;   
--Dimension Fecha
select count(0) into t_did from dim_date  where t_cdate=v_lst_cur_rec.t_date;
    if t_did =0 then 
      insert into dim_date (t_cdate, t_date, t_year, t_quarter, t_month, t_day) 
      values (to_char(v_lst_cur_rec.t_date,'ddmmyyyy'), v_lst_cur_rec.t_date, 
      extract(year from v_lst_cur_rec.t_date),to_char(v_lst_cur_rec.t_date,'Q'),
      extract(month from v_lst_cur_rec.t_date),
      extract(day from v_lst_cur_rec.t_date) );
    end if;        
--
--Checamos que no hayan datos duplicados
select count(0) into t_fact_sale from fact_sale where
            product_id = v_lst_cur_rec.product_id
            and customer_id =v_lst_cur_rec.customer_id
            and store_id = v_lst_cur_rec.store_id
            and supplier_id = v_sid
            and price = v_price
            and quantity = v_lst_cur_rec.quantity
            and t_date = v_lst_cur_rec.t_date;
 --Se termina el chequeo de datos duplicados                                                              
    if t_fact_sale = 0 then
    insert into fact_sale (product_id,customer_id,store_id,supplier_id,t_date,
                        total_sale,price, quantity) 
        values (v_lst_cur_rec.product_id, v_lst_cur_rec.customer_id,
             v_lst_cur_rec.store_id,v_sid,v_lst_cur_rec.t_date,
             v_lst_cur_rec.quantity*v_price,v_price, v_lst_cur_rec.quantity);
    end if; 
      commit; 
      end loop;
      close v_lst_cur;
      commit ;
     rcd := rcd + 50;  
  end loop;
end;



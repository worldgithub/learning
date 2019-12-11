--plsql程序将分页将表A数据 复制到 表B中，只需修改v_pagesize页面容量
 declare
   --总数据量
   v_count number;
   --页面容量
   v_pagesize number := 50;
   --总页数
   v_totalpage number;
   --取余的余数
   v_modnum number;
   --起始rownum
   v_startnum number;
   --终止rownum
   v_endnum number;
   --开始时间
   v_starttime number;
   --结束时间
   v_endtime number;
 begin
   --统计总数
   select count(*) into v_count from sf_base.oss_param_busi_actid;
   DBMS_OUTPUT.put_line('表oss_param_busi_actid共有' || v_count || '条数据。');
   
   --通过取余，判断总共分页数
   select mod(v_count, v_pagesize) into v_modnum from dual;
   if v_modnum=0 then
      v_totalpage :=  v_count / v_pagesize;
   else
      v_totalpage := (v_count - v_modnum) / v_pagesize + 1;
   end if;
   DBMS_OUTPUT.put_line('按照每页' || v_pagesize || '条数据，表oss_param_busi_actid可以分为' || v_totalpage || '页。');
   
   --遍历取每页数据，插入到目标表中
   for v_index in 1..v_totalpage loop
     v_startnum := (v_index - 1)*v_pagesize;
     v_endnum := v_index*v_pagesize;
     --开始时间
     select (sysdate - to_date('1970-1-1 8', 'YYYY-MM-DD HH24')) * 86400000 + to_number(to_char(systimestamp(3), 'FF')) into  v_starttime from dual; 
     --插入sql  
     insert into stu(id, name, age) (
          select b.busi_code, b.busi_name, b.busi_type from (select  t.*, rownum as n from sf_base.            oss_param_busi_actid t) b where n>v_startnum and n<=v_endnum);
	 ---注意点：------请注意commit,提交就入库了---------
	 --commit;
     --结束时间
     select (sysdate - to_date('1970-1-1 8', 'YYYY-MM-DD HH24')) * 86400000 + to_number(to_char(systimestamp(3), 'FF')) into  v_endtime from dual;
     --判断最后一页 
     if v_index=v_totalpage then
        v_endnum := v_count;
     end if;
     DBMS_OUTPUT.put_line('第' ||(v_startnum + 1) || '~' ||v_endnum|| '条数据插入完毕。'|| '总共花费' || (v_endtime - v_starttime) || '毫秒。');
   end loop;
 end; 
/
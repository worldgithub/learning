set trimspool on;　　
set linesize 120; 　　
set pagesize 2000;　　--输出每页行数，缺省为24,为了避免分页，可设定为0。
set newpage 1; 
set feedback off;　　--回显本次sql命令处理的记录条数，缺省为on
set heading off;   --输出域标题，缺省为on　　
set term off;
spool D:\个人资料\exportData.txt
select t.id || ',' || t.name || ',' || t.age from stu t;
spool off
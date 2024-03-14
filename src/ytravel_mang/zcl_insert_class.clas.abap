CLASS zcl_insert_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

       INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_class IMPLEMENTATION.
method if_oo_adt_classrun~main.

  select * from /dmo/travel_m into table @data(lt_tab).
*  if sy-subrc eq 0.
  modify ztravel_man from table @lt_tab.

  out->write( 'Hello world!' ).
*  endif.

ENDMETHOD.
ENDCLASS.

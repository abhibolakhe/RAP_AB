CLASS lhc_ZI_TRAVEL_MAN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_man RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_man.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_MAN IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE travelid IS NOT INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
             EXPORTING
                 nr_range_nr = '01'
                 object = '/DMO/TRV_M'
                 quantity = CONV #( lines( lt_entities ) )
             IMPORTING
                 number = DATA(lv_latest_num)
                 returncode = DATA(lv_code)
                 returned_quantity = DATA(lv_qty) ).

      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).

        LOOP AT lt_entities INTO DATA(ls_entities).

          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key )
               TO failed-zi_travel_man.

          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key
                          %msg = lo_error )
             TO reported-zi_travel_man.
        ENDLOOP.
        EXIT.

    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
    DATA(lv_curr_num) = lv_latest_num - lv_qty.


    LOOP AT lt_entities INTO ls_entities.
      lv_curr_num += lv_curr_num.

      APPEND VALUE #( %cid = ls_entities-%cid
                       travelid = lv_curr_num )
                       TO mapped-zi_travel_man.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

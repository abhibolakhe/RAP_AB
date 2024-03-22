CLASS lhc_ZI_TRAVEL_MAN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_man RESULT result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_man~accepttravel RESULT result.

    METHODS caltotprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_man~caltotprice.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_man~copytravel.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_man~rejecttravel RESULT result.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_man\_booking.

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
          lv_curr_num = lv_curr_num + 10.
                 APPEND VALUE #( %cid = ls_entities-%cid
                           travelid = lv_curr_num )
               TO mapped-zi_travel_man.
        ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA: lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travel_man IN LOCAL MODE
    ENTITY zi_travel_man BY \_booking
    FROM CORRESPONDING #( entities )
    RESULT DATA(lt_link_data)
    FAILED DATA(lt_failed_data).


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                               GROUP BY <ls_group_entity>-TravelId.

* get highest assigned booking_id travel belonging to booking
      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                  FOR ls_link IN lt_link_data USING KEY entity
                                  WHERE  ( TravelId = <ls_group_entity>-TravelId )
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-BookingId
                                                                      THEN ls_link-BookingId
                                                                      ELSE lv_max ) ).

* get highest assigned booking_id from incoming entities
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                  FOR ls_entity IN entities USING KEY entity
                                  WHERE  ( TravelId = <ls_group_entity>-TravelId )
                                  FOR ls_booking IN ls_entity-%target
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                      THEN ls_booking-BookingId
                                                                      ELSE lv_max ) ).

* loop over all entities in entities with the same travelID
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity
                                 WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_booking_man ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
* assign new booking_ID
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.
            <ls_new_map_book>-BookingId = lv_max_booking.
          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

  METHOD acceptTravel.
  ENDMETHOD.

  METHOD calTotPrice.
  ENDMETHOD.

  METHOD copyTravel.

    DATA: lt_travel_cr      TYPE TABLE FOR CREATE zi_travel_man,
          lt_booking_cr     TYPE TABLE FOR CREATE zi_travel_man\_booking,
          lt_bookingsupp_cr TYPE TABLE FOR CREATE zi_booking_man\_bookingsupply.


    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zi_travel_man IN LOCAL MODE
        ENTITY zi_travel_man
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel_r)
        FAILED DATA(lt_failed_r).

    READ ENTITIES OF zi_travel_man IN LOCAL MODE
        ENTITY zi_travel_man BY \_booking
        ALL FIELDS WITH CORRESPONDING #( lt_travel_r  )
        RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_travel_man IN LOCAL MODE
        ENTITY zi_booking_man BY \_bookingsupply
        ALL FIELDS WITH CORRESPONDING #( lt_booking_r  )
        RESULT DATA(lt_bookingsupply_r).


    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

      APPEND VALUE #( %cid = keys[ KEY entity travelid = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT travelid ) )
                 TO lt_travel_cr ASSIGNING FIELD-SYMBOL(<ls_travel_cr>).

      <ls_travel_cr>-BeginDate = cl_abap_context_info=>get_system_date(  ).
      <ls_travel_cr>-EndDate   = cl_abap_context_info=>get_system_date(  ) + 30.
      <ls_travel_cr>-OverallStatus = 'O'.


      APPEND VALUE #( %cid_ref = <ls_travel_cr>-%cid )
                 TO lt_booking_cr ASSIGNING FIELD-SYMBOL(<ls_booking_cr>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                                     USING KEY entity
                                     WHERE travelid = <ls_travel_r>-TravelId.

         APPEND VALUE #(  %cid = <ls_travel_cr>-%cid && <ls_booking_r>-BookingId
                         %data = CORRESPONDING #( <ls_booking_r> EXCEPT travelid )  )
                    TO <ls_booking_cr>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

        <ls_booking_n>-BookingStatus = 'N'.


        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
                   TO lt_bookingsupp_cr ASSIGNING FIELD-SYMBOL(<ls_bookingsupp_cr>).

        LOOP AT lt_bookingsupply_r ASSIGNING FIELD-SYMBOL(<ls_bookingsupply_r>)
                                   USING KEY entity
                                   WHERE travelid = <ls_travel_r>-TravelId
                                   AND   BookingId = <ls_booking_r>-BookingId.


          APPEND VALUE #( %cid = <ls_travel_cr>-%cid && <ls_booking_r>-BookingId
                                                     && <ls_bookingsupply_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_bookingsupply_r> EXCEPT travelid BookingId ) )
                         TO <ls_bookingsupp_cr>-%target.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_man IN LOCAL MODE
    ENTITY zi_travel_man
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode Description OverallStatus  )
    WITH lt_travel_cr
    ENTITY zi_travel_man
    CREATE BY \_booking
    FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    WITH lt_booking_cr
    ENTITY zi_booking_man
    CREATE BY \_bookingsupply
    FIELDS ( BookingSupplementId SupplementId Price CurrencyCode  )
    WITH lt_bookingsupp_cr
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed).

    Mapped-zi_travel_man = lt_mapped-zi_travel_man.

  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

ENDCLASS.

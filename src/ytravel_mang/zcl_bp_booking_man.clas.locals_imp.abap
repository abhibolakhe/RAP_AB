CLASS lhc_zi_booking_man DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_booking_man\_Bookingsupply.

ENDCLASS.

CLASS lhc_zi_booking_man IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA: lv_max_booking_suppid TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_man IN LOCAL MODE
     ENTITY zi_booking_man BY \_bookingsupply
     FROM CORRESPONDING #( entities )
     RESULT DATA(lt_link_booking_supply).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_booking_group>)
                                 GROUP BY <ls_booking_group>-%tky.

* get highest assigned bookingsupplement_id booking belonging to bookingsupplment
      lv_max_booking_suppid = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                  FOR ls_link_book_supp IN lt_link_booking_supply USING KEY entity
                                  WHERE  ( TravelId = <ls_booking_group>-TravelId
                                       AND BookingId = <ls_booking_group>-BookingId )
                                  NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < ls_link_book_supp-BookingSupplementId
                                                                      THEN ls_link_book_supp-BookingSupplementId
                                                                      ELSE lv_max ) ).

* get highest assigned bookingsupplement_id from incoming entities
      lv_max_booking_suppid = REDUCE #( INIT lv_max = lv_max_booking_suppid
                                   FOR ls_entity IN entities USING KEY entity
                                   WHERE  ( TravelId = <ls_booking_group>-TravelId
                                        AND BookingId = <ls_booking_group>-BookingId )
                                   FOR ls_booking_supp IN ls_entity-%target
                                   NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking_supp-BookingSupplementId
                                                                       THEN ls_booking_supp-BookingSupplementId
                                                                   ELSE lv_max ) ).

* loop over all entities in entities with the same travelID & bookingID
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity
                                   WHERE TravelId = <ls_booking_group>-TravelId
                                   AND BookingId = <ls_booking_group>-BookingId.

* assign new bookingsupply_ID
        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_suppid>).

          APPEND CORRESPONDING #( <ls_booking_suppid> ) TO mapped-zi_booksupp_man
                                              ASSIGNING FIELD-SYMBOL(<ls_new_map_booksupp>).

          IF <ls_booking_suppid>-BookingSupplementId IS INITIAL.
            lv_max_booking_suppid += 1.
            <ls_new_map_booksupp>-BookingSupplementId = lv_max_booking_suppid.
          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

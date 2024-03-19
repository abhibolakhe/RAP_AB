@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOKING_MAN
  as select from zbooking_man
  association        to parent ZI_TRAVEL_MAN     as _travel         on  $projection.TravelId = _travel.TravelId
  composition [0..*] of ZI_BOOKSUPP_MAN          as _bookingsupply
  association [1..1] to /DMO/I_Carrier           as _carrier        on  $projection.CarrierId = _carrier.AirlineID
  association [1..1] to /DMO/I_Customer          as _customer       on  $projection.CustomerId = _customer.CustomerID
  association [1..1] to /DMO/I_Connection        as _connection     on  $projection.CarrierId    = _connection.AirlineID
                                                                    and $projection.ConnectionId = _connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _booking_status on  $projection.BookingStatus = _booking_status.BookingStatus
{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      // use this field as ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,
      _bookingsupply,
      _travel,
      _carrier,
      _customer,
      _connection,
      _booking_status
}

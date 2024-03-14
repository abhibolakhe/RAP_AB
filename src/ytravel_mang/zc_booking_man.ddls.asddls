@EndUserText.label: 'booking projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_BOOKING_MAN as projection on ZI_BOOKING_MAN
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _bookingsupply : redirected to composition child ZC_BOOKSUPP_MAN,
    _booking_status,
    _carrier,
    _connection,
    _customer,
    _travel: redirected to parent ZC_TRAVEL_MAN
}

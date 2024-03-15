@EndUserText.label: 'booking projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_BOOKING_MAN as projection on ZI_BOOKING_MAN
{
    key TravelId,
    key BookingId,
    BookingDate,
    @ObjectModel.text.element: [ 'customerName' ]
    CustomerId,
    _customer.LastName as customerName,
    @ObjectModel.text.element: [ 'carrierName' ]
    CarrierId,
    _carrier.Name as carrierName,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    @ObjectModel.text.element: [ 'bookingText' ]
    BookingStatus,
    _booking_status._Text.Text as bookingText : localized,
    LastChangedAt,
    /* Associations */
    _bookingsupply : redirected to composition child ZC_BOOKSUPP_MAN,
    _booking_status,
    _carrier,
    _connection,
    _customer,
    _travel: redirected to parent ZC_TRAVEL_MAN
}

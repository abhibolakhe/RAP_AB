@EndUserText.label: 'approval for booking application'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: { typeName: 'Booking' , typeNamePlural: 'Boookings',
title: { type: #STANDARD, label: 'Booking', value: 'BookingId'}
}
define view entity ZC_BOOKING_APPROVAL_MAN as projection on ZI_BOOKING_MAN
{

     @UI.lineItem: [{ position: 10 }]
    key TravelId,
    @UI.lineItem: [{ position: 20 }]
    key BookingId,
    @UI.lineItem: [{ position: 30 }]
    BookingDate,
    @UI.lineItem: [{ position: 40 }]
    @ObjectModel.text.element: [ 'customberName' ]
    CustomerId,
    _customer.LastName as customberName,
    @UI.lineItem: [{ position: 50 }]
    @ObjectModel.text.element: [ 'carrierName' ]
    CarrierId,
    _carrier.Name as carrierName,
    @UI.lineItem: [{ position: 60 }]
    ConnectionId,
    @UI.lineItem: [{ position: 70 }]
    FlightDate,
    @UI.lineItem: [{ position: 80 }]
    FlightPrice,
    @UI.lineItem: [{ position: 90 }]
    CurrencyCode,
    @ObjectModel.text.element: [ 'bookingText' ]
    @UI.lineItem: [{ position: 91 }]
    BookingStatus,
     _booking_status._Text.Text as bookingText : localized,
      @UI.hidden: true
    LastChangedAt,
    /* Associations */
    _bookingsupply,
    _booking_status,
    _carrier,
    _connection,
    _customer,
    _travel : redirected to parent ZC_TRAVEL_APPROVAL_MAN
}

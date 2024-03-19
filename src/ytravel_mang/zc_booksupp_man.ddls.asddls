@EndUserText.label: 'Booking supplement projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_BOOKSUPP_MAN
  as projection on ZI_BOOKSUPP_MAN
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'suppdesc' ]
      SupplementId,
      _supplytext.Description as suppdesc : localized,
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _booking : redirected to parent ZC_BOOKING_MAN,
      _supply,
      _supplytext,
      _travel : redirected to ZC_TRAVEL_MAN
}

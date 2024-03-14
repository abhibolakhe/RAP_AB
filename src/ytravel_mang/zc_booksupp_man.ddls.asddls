@EndUserText.label: 'Booking supplement projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_BOOKSUPP_MAN
  as projection on ZI_BOOKSUPP_MAN
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _booking : redirected to parent ZC_BOOKING_MAN,
      _supply,
      _supplytext,
      _travel
}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking supplement'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOKSUPP_MAN
  as select from zbooksupp_man
  association        to parent ZI_BOOKING_MAN as _booking    on  $projection.TravelId  = _booking.TravelId
                                                             and $projection.BookingId = _booking.BookingId
  association [1..1] to ZI_TRAVEL_MAN         as _travel     on  $projection.TravelId = _travel.TravelId
  association [1..1] to /DMO/I_Supplement     as _supply     on  $projection.SupplementId = _supply.SupplementID
  association [1..*] to /DMO/I_SupplementText as _supplytext on  $projection.SupplementId = _supplytext.SupplementID

{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      // use this field as ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _travel,
      _booking,
      _supply,
      _supplytext

}

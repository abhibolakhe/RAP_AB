@EndUserText.label: 'travel projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_TRAVEL_MAN
  provider contract transactional_query
  as projection on ZI_TRAVEL_MAN
{
  key TravelId,
      AgencyId,
      _agency.Name       as agencName,
      CustomerId,
      _customer.LastName as customerName,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus,
      _status._Text.Text : localized,
      //      CreatedBy,
      //      CreatedAt,
      //      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _agency,
      _booking : redirected to composition child ZC_BOOKING_MAN,
      _currency,
      _customer,
      _status
}

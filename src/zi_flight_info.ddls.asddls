@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight information'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_FLIGHT_INFO as select from /dmo/flight
 association [1..1] to ZI_CARRIER_INFO as carr_info on $projection.CarrierId = carr_info.CarrierId
{
    @UI.lineItem: [{ position: 21 }]
    @ObjectModel.text.association: 'carr_info'
    key carrier_id as CarrierId,
    @UI.lineItem: [{ position: 31 }]
    key connection_id as ConnectionId,
    @UI.lineItem: [{ position: 41 }]
    key flight_date as FlightDate,
    @UI.lineItem: [{ position: 51 }]
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    @UI.lineItem: [{ position: 61 }]
    @Search.defaultSearchElement: true
    plane_type_id as PlaneTypeId,
    @UI.lineItem: [{ position: 71 }]
    seats_max as SeatsMax,
    @UI.lineItem: [{ position: 81 }]
    seats_occupied as SeatsOccupied,
    carr_info
}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airport value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_AIRPOTRT_INFO as select from /dmo/airport
{
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    key airport_id as AirportId,
    @Search.defaultSearchElement: true
     @Search.fuzzinessThreshold: 0.8
    name as Name,
    @Search.defaultSearchElement: true
     @Search.fuzzinessThreshold: 0.8
    city as City,
    @Search.defaultSearchElement: true
     @Search.fuzzinessThreshold: 0.8
    country as Country
}

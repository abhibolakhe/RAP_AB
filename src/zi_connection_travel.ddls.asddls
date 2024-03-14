@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'travel connection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'Connection' , typeNamePlural: 'Connections' }
@Search.searchable: true
define view entity ZI_CONNECTION_TRAVEL
  as select from /dmo/connection as Connection
  association [1..*] to ZI_FLIGHT_INFO  as fli_info  on  $projection.CarrierId    = fli_info.CarrierId
                                                     and $projection.ConnectionId = fli_info.ConnectionId
  association [1..1] to ZI_CARRIER_INFO as carr_info on  $projection.CarrierId = carr_info.CarrierId

{
      @UI.facet: [{ id: 'Connection',
                    purpose: #STANDARD ,
                    type: #IDENTIFICATION_REFERENCE,
                    position: 10,
                    label: 'Connection Detail' },

                    { id: 'Flight',
                    purpose: #STANDARD ,
                    type: #LINEITEM_REFERENCE,
                    position: 20,
                    label: 'Flights Detail',
                    targetElement: 'fli_info'
                    }
                    ]

      @UI.lineItem: [{ position: 21, label: 'Airline Number'  }]
      @UI.identification: [{ position: 10, label: 'Airline'}]
      @ObjectModel.text.association: 'carr_info'
      @Search.defaultSearchElement: true
  key carrier_id      as CarrierId,
      @UI.lineItem: [{ position: 20 , label: 'Airline Name'  }]
      @UI.identification: [{ position: 20 }]
  key connection_id   as ConnectionId,
      @UI.lineItem: [{ position: 30 , label: 'Departure Airport ID' }]
      @UI.identification: [{ position: 30 }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_AIRPOTRT_INFO', entity.element: 'AirportId' }]
      @EndUserText.label: 'Departure Airport ID'
      airport_from_id as AirportFromId,
      @UI.lineItem: [{ position: 40 , label: 'Destination Airport ID' }]
      @UI.identification: [{ position: 40 }]
      @UI.selectionField: [{ position: 20 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_AIRPOTRT_INFO', entity.element: 'AirportId' }]
      @EndUserText.label: 'Destination Airport ID'
      airport_to_id   as AirportToId,
      @UI.lineItem: [{ position: 50, label: 'Departure Time' }]
      @UI.identification: [{ position: 50 }]
      departure_time  as DepartureTime,
      @UI.lineItem: [{ position: 60, label: 'Arrival Time' }]
      @UI.identification: [{ position: 60 }]
      arrival_time    as ArrivalTime,
      @UI.lineItem: [{ position: 70 }]
      distance        as Distance,
      @UI.lineItem: [{ position: 80 }]
      distance_unit   as DistanceUnit,
      // Association
      @Search.defaultSearchElement: true
      fli_info,
      @Search.defaultSearchElement: true
      carr_info
}

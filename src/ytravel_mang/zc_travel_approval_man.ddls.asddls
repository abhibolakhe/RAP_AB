@EndUserText.label: 'approval for travel application'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@UI.headerInfo: { typeName: 'Travel Admin' , typeNamePlural: 'Travels Admin',
title: { type: #STANDARD, label: 'Travel Admin', value: 'TravelId'}
}
define root view entity ZC_TRAVEL_APPROVAL_MAN
  provider contract transactional_query
  as projection on ZI_TRAVEL_MAN

{
      @UI.facet: [{ id : 'Travel',
           purpose: #STANDARD,
           position: 10,
           label: 'TRAVEL',
           type: #IDENTIFICATION_REFERENCE },
      {
      id : 'Booking',
      purpose: #STANDARD,
      position: 20,
      label: 'BOOKING',
      type: #LINEITEM_REFERENCE,
      targetElement: '_booking'
      }]
      @UI.lineItem: [{ position: 10 },
                      { type: #FOR_ACTION , dataAction: 'acceptTravel', label: 'Accept', position: 10},
                      { type: #FOR_ACTION , dataAction: 'rejectTravel', label: 'Reject', position: 20}]
      @UI.identification: [{ position: 10 },
                      { type: #FOR_ACTION , dataAction: 'acceptTravel', label: 'Accept'},
                      { type: #FOR_ACTION , dataAction: 'rejectTravel', label: 'Reject'}]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key TravelId,
      @UI : { lineItem: [{ position: 30 }] ,
      selectionField: [{ position: 10 }] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{  entity: {name: '/DMO/I_Agency_StdVH' , element: 'AgencyID' } }]
      @UI.identification: [{ position: 20 }]
      @ObjectModel.text.element: [ 'agencyName' ]
      AgencyId,
      _agency.Name       as agencyName,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @ObjectModel.text.element: [ 'customerName' ]
      CustomerId,
      _customer.LastName as customerName,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      BeginDate,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      EndDate,
      //    BookingFee,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Currency' , entity.element: 'Currency' }]
      CurrencyCode,
      @UI : { lineItem: [{ position: 20 } ] ,
      selectionField: [{ position: 30 }], textArrangement: #TEXT_ONLY  }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Overall_Status_VH' , entity.element: 'OverallStatus' }]
      @UI.identification: [{ position: 80 }]
      @ObjectModel.text.element: [ 'statusText' ]
      OverallStatus,
      _status._Text.Text as statusText : localized,
      @UI.identification: [{ position: 70 }]
      Description,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _agency,
      _booking : redirected to composition child ZC_BOOKING_APPROVAL_MAN,
      _currency,
      _customer,
      _status
}

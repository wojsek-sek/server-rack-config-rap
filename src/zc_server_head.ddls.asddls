@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Server Config Header'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SERVER_HEAD 
    provider contract transactional_query
    as projection on ZI_SERVER_HEAD
{
    key ConfigUuid,
    @Search.defaultSearchElement: true
    ProjectName,
    CustomerId,
    TotalPrice,
    Currency,
    TotalPowerW,
    TotalSpaceU,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Items : redirected to composition child ZC_SERVER_ITEM
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Item for Server'
@Metadata.allowExtensions: true
define view entity ZC_SERVER_ITEM as projection on ZI_SERVER_ITEM
{
    key ItemUuid,
    ConfigUuid,
    ComponentId,
    ComponentType,
    Quantity,
    PricePerUnit,
    Currency,
    PowerWPerUnit,
    SpaceUPerUnit,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Server : redirected to parent ZC_SERVER_HEAD
}

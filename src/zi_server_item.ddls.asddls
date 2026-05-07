@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rack Component Item (Child)'
define view entity ZI_SERVER_ITEM
  as select from zserver_item
  // English comment: The ASSOCIATION TO PARENT keyword links the child back to the root entity using the ConfigUuid foreign key.
  association to parent ZI_SERVER_HEAD as _Server on $projection.ConfigUuid = _Server.ConfigUuid
{
  key item_uuid as ItemUuid,
  config_uuid as ConfigUuid,
  component_id as ComponentId,
  component_type as ComponentType,
  quantity as Quantity,
  
  @Semantics.amount.currencyCode: 'Currency'
  price_per_unit as PricePerUnit,
  currency as Currency,
  power_w_per_unit as PowerWPerUnit,
  space_u_per_unit as SpaceUPerUnit,
  
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,

  /* Public Associations */
  _Server
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Server Config Header (Root)'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SERVER_HEAD as select from ZSERVERRACK
// English comment: The COMPOSITION keyword is crucial. It tells the framework that the Item view is a dependent child of this Header.
  composition [0..*] of ZI_SERVER_ITEM as _Items
{
    key config_uuid as ConfigUuid,
    project_name as ProjectName,
    customer_id as CustomerId,
      
    @Semantics.amount.currencyCode: 'Currency'
    total_price as TotalPrice,
    currency as Currency,
    total_power_w as TotalPowerW,
    total_space_u as TotalSpaceU,
      
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
    _Items
}

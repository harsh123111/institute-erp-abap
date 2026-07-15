@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Values Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@Metadata.allowExtensions: true
define view entity ZI_STATUS_VHP
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                 p_domain_name: 'ZIACSD_STATUS'
                 )
{
  key domain_name,
  key value_position,
  key language,
  key value_low as Status,

      @Semantics.text: true
      text      as StatusText
}

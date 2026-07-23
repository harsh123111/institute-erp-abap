@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Faculty interface view'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZI_IACSD_FACULTIES as select from ziacsd_faculties
//composition of target_data_source_name as _association_name
{
    key faculty_id as FacultyId,
    
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Faculty Name'
    faculty_name as FacultyName,
    email as Email,
    phone as Phone,
    status as Status,
    department as Department,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
   // _association_name // Make association public
}

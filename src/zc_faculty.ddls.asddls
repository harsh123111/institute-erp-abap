@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Faculty projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_FACULTY provider contract transactional_query as projection on ZI_IACSD_FACULTIES
{
    key FacultyId,
    FacultyName,
    Email,
    Phone,
    Status,
    Department,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}

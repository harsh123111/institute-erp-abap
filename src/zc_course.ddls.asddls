@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'course projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZC_COURSE provider contract transactional_query
as projection on ZI_IACSD_COURSE

{
    key CourseId,
    CourseName,
    Description,
    Status,
    Duration,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    _Subject : redirected to composition child ZC_SUBJECT
}

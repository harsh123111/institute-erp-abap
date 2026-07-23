@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view of Subject'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_SUBJECT as projection on ZI_IACSD_SUBJECT
{
    key SubjectId,
    SubjectName,
    CourseId,
    Description,
    Duration,
    Status,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
  
    /* Associations */
    _Course : redirected to parent ZC_COURSE
}

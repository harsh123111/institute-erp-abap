@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'subject interface view'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZI_IACSD_SUBJECT as select from ziacsd_subject
association to parent ZI_IACSD_COURSE as _Course
    on $projection.CourseId = _Course.CourseId
{
    key subject_id as SubjectId,
     @Search.defaultSearchElement: true
      @EndUserText.label: 'Subject Name'
    subject_name as SubjectName,
    course_id as CourseId,
    description as Description,
    duration as Duration,
    status as Status,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    _Course // Make association public
}

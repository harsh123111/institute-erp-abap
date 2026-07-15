@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'course_interface view'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZI_IACSD_COURSE
  as select from ziacsdcourse

{
  key course_id       as CourseId,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Course Name'
      course_name     as CourseName,
      description     as Description,
      status          as Status,
      duration        as Duration,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}

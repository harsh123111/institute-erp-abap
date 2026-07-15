@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Subject Basic Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_i_subject as select from ziacsd_subject
//association [1..1] to zi_i_course as _Course
    //on $projection.CourseId = _Course.CourseId
{
    key subject_id as SubjectId,
    subject_name as SubjectName,
    course_id as CourseId,
    duration as Duration,
    status as Status
   // _Course // Make association public
}

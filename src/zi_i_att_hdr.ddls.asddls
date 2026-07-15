@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view of attendance HDR'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_i_att_hdr as select from ziacsd_att_hdr
composition [0..*] of ZI_I_ATT_ITEM as _Items
{
    key attendance_id as AttendanceId,
    subject_id as SubjectId,
    faculty_id as FacultyId,
    attendance_date as AttendanceDate,
    batch_id as BatchId,
    created_by as CreatedBy,
    created_at as CreatedAt,
   // _association_name // Make association public
   _Items
}

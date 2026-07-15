@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view of attendance Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_I_ATT_ITEM as select from ziacsd_att_item
association to parent zi_i_att_hdr as _Header
    on $projection.AttendanceId = _Header.AttendanceId
{
    key attendance_id as AttendanceId,
    key student_id as StudentId,
    status as Status,
    remarks as Remarks,
     // Make association public
     _Header
}

CLASS ziacsd_cl_test_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ziacsd_cl_test_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*DATA: lt_interval TYPE cl_numberrange_intervals=>nr_interval,
*      lv_error    TYPE cl_numberrange_intervals=>nr_error,
*      lv_warning  TYPE cl_numberrange_intervals=>nr_warning,
*      lv_error_iv TYPE cl_numberrange_intervals=>nr_error_iv,
*      lv_errorinf TYPE cl_numberrange_intervals=>nr_error_inf.
*
*APPEND INITIAL LINE TO lt_interval ASSIGNING FIELD-SYMBOL(<ls_interval>).
*
*<ls_interval>-subobject  = ''.
*<ls_interval>-nrrangenr  = '01'.
*<ls_interval>-toyear     = '0000'.      "No year dependency
*<ls_interval>-fromnumber = '1'.
*<ls_interval>-tonumber   = '20'.
*<ls_interval>-nrlevel    = '0'.         "Current level
*<ls_interval>-externind  = space.       "Internal numbering
*<ls_interval>-procind    = 'I'.         "Insert
*
*TRY.
*
*    cl_numberrange_intervals=>create(
*      EXPORTING
*        object   = 'Z_COURSE_N'
*        interval = lt_interval
*      IMPORTING
*        error    = lv_error
*        warning  = lv_warning
*        error_iv = lv_error_iv
*        error_inf = lv_errorinf ).
*
*    out->write( 'Interval Created Successfully' ).
*
*  CATCH cx_number_ranges INTO DATA(lx).
*    out->write( lx->get_text( ) ).
*
*
*ENDTRY.
DATA lv_rc TYPE cl_numberrange_runtime=>nr_returncode.
DATA lv_num TYPE cl_numberrange_runtime=>nr_number.

TRY.
    cl_numberrange_runtime=>number_get(
      EXPORTING
        object      = 'Z_COURSE_N'
        nr_range_nr = '01'
      IMPORTING
        number      = lv_num
        returncode  = lv_rc ).

    out->write( lv_num ).

  CATCH cx_number_ranges INTO DATA(lx).
    out->write( lx->get_text( ) ).
ENDTRY.


* DELETE FROM ziacsd_attendanc WHERE attend_id <> ''.
*    IF sy-subrc = 0.
*      out->write( '✅ Attendance deleted' ).
*    ELSE.
*      out->write( '⚠️ Attendance already empty' ).
*    ENDIF.
*
*    " Delete Students
*    DELETE FROM ziacsd_student WHERE student_id <> ''.
*    IF sy-subrc = 0.
*      out->write( '✅ Students deleted' ).
*    ELSE.
*      out->write( '⚠️ Students already empty' ).
*    ENDIF.
*
*    " Delete Subjects
*    DELETE FROM ziacsd_subject WHERE subject_id <> ''.
*    IF sy-subrc = 0.
*      out->write( '✅ Subjects deleted' ).
*    ELSE.
*      out->write( '⚠️ Subjects already empty' ).
*    ENDIF.
*
*    " Delete Faculties
*    DELETE FROM ziacsd_faculties WHERE faculty_id <> ''.
*    IF sy-subrc = 0.
*      out->write( '✅ Faculties deleted' ).
*    ELSE.
*      out->write( '⚠️ Faculties already empty' ).
*    ENDIF.
*
*    " Delete Courses
*    DELETE FROM ziacsdcourse WHERE course_id <> ''.
*    IF sy-subrc = 0.
*      out->write( '✅ Courses deleted' ).
*    ELSE.
*      out->write( '⚠️ Courses already empty' ).
*    ENDIF.
*
*    COMMIT WORK.
*    out->write( '================================' ).
*    out->write( '✅ All data deleted successfully' ).
*    out->write( '================================' ).
** " Day 1 — 09 March 2026
* INSERT ziacsd_attendanc FROM TABLE @( VALUE #(
*      ( client       = sy-mandt
*        attend_id   = 'ATT000001'
*        student_id  = 'STU001'
*        subject_id  = 'SUB001'
*        attend_date = '20260309'
*        status      = 'P'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000002'
*        student_id  = 'STU002'
*        subject_id  = 'SUB001'
*        attend_date = '20260309'
*        status      = 'P'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000003'
*        student_id  = 'STU003'
*        subject_id  = 'SUB001'
*        attend_date = '20260309'
*        status      = 'A'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000004'
*        student_id  = 'STU004'
*        subject_id  = 'SUB004'
*        attend_date = '20260309'
*        status      = 'P'
*        marked_by   = 'FAC003'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*
*      " Day 2 — 10 March 2026
*      ( client       = sy-mandt
*        attend_id   = 'ATT000005'
*        student_id  = 'STU001'
*        subject_id  = 'SUB001'
*        attend_date = '20260310'
*        status      = 'P'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000006'
*        student_id  = 'STU002'
*        subject_id  = 'SUB001'
*        attend_date = '20260310'
*        status      = 'L'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000007'
*        student_id  = 'STU003'
*        subject_id  = 'SUB001'
*        attend_date = '20260310'
*        status      = 'P'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000008'
*        student_id  = 'STU004'
*        subject_id  = 'SUB004'
*        attend_date = '20260310'
*        status      = 'A'
*        marked_by   = 'FAC003'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*
*      " Day 3 — 11 March 2026
*      ( client       = sy-mandt
*        attend_id   = 'ATT000009'
*        student_id  = 'STU001'
*        subject_id  = 'SUB001'
*        attend_date = '20260311'
*        status      = 'P'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000010'
*        student_id  = 'STU002'
*        subject_id  = 'SUB001'
*        attend_date = '20260311'
*        status      = 'P'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000011'
*        student_id  = 'STU003'
*        subject_id  = 'SUB001'
*        attend_date = '20260311'
*        status      = 'A'
*        marked_by   = 'FAC001'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*      ( client       = sy-mandt
*        attend_id   = 'ATT000012'
*        student_id  = 'STU004'
*        subject_id  = 'SUB004'
*        attend_date = '20260311'
*        status      = 'P'
*        marked_by   = 'FAC003'
*        batch       = 'Feb-26 Batch A'
*        created_at  = '120000' )
*    ) ).
*
*    IF sy-subrc = 0.
*      out->write( '✅ Attendance records inserted' ).
*    ELSE.
*      out->write( |❌ Attendance failed - subrc: { sy-subrc }| ).
*    ENDIF.
*
*    COMMIT WORK.
*    out->write( '✅ Committed successfully' ).
   " Check Basic Interface View
*    SELECT COUNT(*) FROM zi_iacsd_attendance
*      INTO @DATA(lv_zi).
*    out->write( |ZI_IACSD_ATTENDANCE count: { lv_zi }| ).
*
*    " Check Student View
*    SELECT COUNT(*) FROM zi_iacsd_student
*      INTO @DATA(lv_st).
*    out->write( |ZI_IACSD_STUDENT count: { lv_st }| ).
*
*    " Check Subject View
*    SELECT COUNT(*) FROM zi_iacsd_subject
*      INTO @DATA(lv_sub).
*    out->write( |ZI_IACSD_SUBJECT count: { lv_sub }| ).
*
*    " Check Projection View
*    SELECT COUNT(*) FROM zc_iacsd_attendance
*      INTO @DATA(lv_zc).
*    out->write( |ZC_IACSD_ATTENDANCE count: { lv_zc }| ).
*
*      SELECT COUNT(*) FROM ziacsd_attend_d
*      INTO @DATA(lv_count).
*    out->write( |Draft table count: { lv_count }| ).
*    INSERT ziacsdcourse FROM TABLE @( VALUE #(
*        ( client          = sy-mandt
*          course_id      = 'DAC'
*          course_name    = 'Diploma in Advanced Computing'
*          description    = 'DAC Course'
*          duration = '24'
*          status         = 'A' )
*        ( client          = sy-mandt
*          course_id      = 'DBDA'
*          course_name    = 'Diploma in Big Data Analytics'
*          description    = 'DBDA Course'
*          duration = '24'
*          status         = 'A' )
*        ( client          = sy-mandt
*        course_id      = 'DITISS'
*        course_name    = 'Diploma in IT Infra Systems'
*        description    = 'DITISS Course'
*        duration = '24'
*        status         = 'A' )
*      ) ).
*
*    IF sy-subrc = 0.
*      out->write( '✅ Courses inserted' ).
*    ELSE.
*      out->write( '❌ Courses failed' ).
*    ENDIF.
    "-----------------
*     INSERT ziacsd_faculties FROM TABLE @( VALUE #(
*      ( client      = sy-mandt
*        faculty_id = 'FAC001'
*        first_name = 'Harshal'
*        last_name  = 'Patil'
*        email      = 'harshal@iacsd.com'
*        phone      = '8698123111'
*        status     = 'A' )
*      ( client      = sy-mandt
*        faculty_id = 'FAC002'
*        first_name = 'Neelam'
*        last_name  = 'Sharma'
*        email      = 'neelam@iacsd.com'
*        phone      = '7894562320'
*        status     = 'A' )
*      ( client      = sy-mandt
*        faculty_id = 'FAC003'
*        first_name = 'Vaibhav'
*        last_name  = 'Kulkarni'
*        email      = 'vaibhav@iacsd.com'
*        phone      = '6547891234'
*        status     = 'A' )
*    ) ).
*
*    IF sy-subrc = 0.
*      out->write( '✅ Faculties inserted' ).
*    ELSE.
*      out->write( '❌ Faculties failed' ).
*    ENDIF.
*----------------------------------------------
* INSERT ziacsd_subject FROM TABLE @( VALUE #(
*      ( client        = sy-mandt
*        subject_id   = 'SUB001'
*        subject_name = 'Core Java'
*        course_id    = 'DAC'
*        duration     = '030'
*        status       = 'A' )
*      ( client        = sy-mandt
*        subject_id   = 'SUB002'
*        subject_name = 'Advanced Java'
*        course_id    = 'DAC'
*        duration     = '020'
*        status       = 'A' )
*      ( client        = sy-mandt
*        subject_id   = 'SUB003'
*        subject_name = 'Linux'
*        course_id    = 'DAC'
*        duration     = '015'
*        status       = 'A' )
*      ( client        = sy-mandt
*        subject_id   = 'SUB004'
*        subject_name = 'DBT'
*        course_id    = 'DAC'
*        duration     = '025'
*        status       = 'A' )
*    ) ).
*
*    IF sy-subrc = 0.
*      out->write( '✅ Subjects inserted' ).
*    ELSE.
*      out->write( '❌ Subjects failed' ).
*    ENDIF.
**
*"--------------------------------------------------------------------
*" INSERT STUDENTS
*"--------------------------------------------------------------------
*    INSERT ziacsd_student FROM TABLE @( VALUE #(
*      ( client     = sy-mandt
*        student_id = 'STU001'
*        roll_no    = '262001'
*        first_name = 'Abhishek'
*        last_name  = 'Adagale'
*        email      = 'abhishek@gmail.com'
*        phone      = '7894561253'
*        course_id  = 'DAC'
*        mentor_id  = 'FAC001'
*        batch      = 'Feb-26 Batch A'
*        join_date  = '20260101'
*        status     = 'A' )
*      ( client      = sy-mandt
*        student_id = 'STU002'
*        roll_no    = '262002'
*        first_name = 'Aditi'
*        last_name  = 'Wale'
*        email      = 'aditi@gmail.com'
*        phone      = '7894561254'
*        course_id  = 'DAC'
*        mentor_id  = 'FAC001'
*        batch      = 'Feb-26 Batch A'
*        join_date  = '20260101'
*        status     = 'A' )
*      ( client      = sy-mandt
*        student_id = 'STU003'
*        roll_no    = '262003'
*        first_name = 'Aditya'
*        last_name  = 'Molwane'
*        email      = 'aditya@gmail.com'
*        phone      = '7894561255'
*        course_id  = 'DAC'
*        mentor_id  = 'FAC002'
*        batch      = 'Feb-26 Batch A'
*        join_date  = '20260101'
*        status     = 'A' )
*      ( client      = sy-mandt
*        student_id = 'STU004'
*        roll_no    = '262004'
*        first_name = 'Ankita'
*        last_name  = 'Mane'
*        email      = 'ankita@gmail.com'
*        phone      = '7894561256'
*        course_id  = 'DBDA'
*        mentor_id  = 'FAC003'
*        batch      = 'Feb-26 Batch A'
*        join_date  = '20260101'
*        status     = 'A' )
*    ) ).
*
*    IF sy-subrc = 0.
*      out->write( '✅ Students inserted' ).
*    ELSE.
*      out->write( '❌ Students failed' ).
*    ENDIF.
*
*"--------------------------------------------------------------------
*" COMMIT
*"--------------------------------------------------------------------
*    COMMIT WORK.
*    out->write( '================================' ).
*    out->write( '✅ All test data committed!' ).
*    out->write( '================================' ).

  ENDMETHOD.
ENDCLASS.

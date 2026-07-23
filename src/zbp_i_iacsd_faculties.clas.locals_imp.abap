CLASS lhc_Faculty DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Faculty RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Faculty RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Faculty.
    METHODS get_last_number
      RETURNING VALUE(rv_last_number) TYPE i.

ENDCLASS.

CLASS lhc_Faculty IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
  DATA lv_max TYPE i.
    lv_max = get_last_number( ).
    LOOP AT entities INTO DATA(ls_entity).
    APPEND INITIAL LINE TO mapped-faculty ASSIGNING FIELD-SYMBOL(<ls_map>).

      <ls_map>-%cid      = ls_entity-%cid.
      <ls_map>-%is_draft = ls_entity-%is_draft.
      "If CourseId already exists, keep it
      IF ls_entity-FacultyId IS NOT INITIAL.
        <ls_map>-%key-FacultyId = ls_entity-FacultyId.
      ELSE.
        lv_max += 1.
        <ls_map>-%key-FacultyId = |{ lv_max }|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_last_number.
      SELECT MAX( faculty_id )
     FROM ziacsd_faculties
     INTO @DATA(lv_active).

    SELECT MAX( facultyid )
      FROM ziacsdfaculty_d
      INTO @DATA(lv_draft).

    rv_last_number = COND i(
                        WHEN lv_active > lv_draft
                        THEN CONV i( lv_active )
                        ELSE CONV i( lv_draft ) ).
     IF rv_last_number < 250.
      rv_last_number = 250.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
